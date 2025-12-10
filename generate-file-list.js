import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const filesDir = path.join(__dirname, 'public', 'files');
const apiDir = path.join(__dirname, 'public', 'api');
const outputPath = path.join(apiDir, 'files.json');
const manifestPath = path.join(__dirname, 'src', 'file-manifest.json');

function scanDirectory(dirPath, relativePath = '') {
  const items = [];
  
  if (!fs.existsSync(dirPath)) {
    return items;
  }

  const entries = fs.readdirSync(dirPath);
  
  // 先收集所有项目
  const folders = [];
  const files = [];
  
  entries.forEach(entry => {
    const fullPath = path.join(dirPath, entry);
    const stats = fs.statSync(fullPath);
    const relPath = relativePath ? `${relativePath}/${entry}` : entry;
    
    if (stats.isDirectory()) {
      folders.push({
        name: entry,
        path: relPath,
        type: 'folder',
        size: 0,
        modifiedDate: stats.mtime.toISOString(),
        children: scanDirectory(fullPath, relPath)
      });
    } else {
      files.push({
        name: entry,
        path: relPath,
        type: 'file',
        size: stats.size,
        modifiedDate: stats.mtime.toISOString()
      });
    }
  });
  
  // 按名称排序
  folders.sort((a, b) => a.name.localeCompare(b.name, 'zh-CN'));
  files.sort((a, b) => a.name.localeCompare(b.name, 'zh-CN'));
  
  // 文件夹优先，然后是文件
  return [...folders, ...files];
}

function flattenWithIds(items, parentPath = '', startId = 1) {
  let id = startId;
  const result = [];
  
  items.forEach(item => {
    const currentItem = {
      id: id++,
      name: item.name,
      path: item.path,
      type: item.type,
      size: item.size,
      modifiedDate: item.modifiedDate,
      parentPath: parentPath
    };
    
    if (item.type === 'folder' && item.children) {
      currentItem.hasChildren = item.children.length > 0;
      result.push(currentItem);
      
      // 递归处理子项
      const childResults = flattenWithIds(item.children, item.path, id);
      result.push(...childResults.items);
      id = childResults.nextId;
    } else {
      result.push(currentItem);
    }
  });
  
  return { items: result, nextId: id };
}

function generateFileList() {
  if (!fs.existsSync(filesDir)) {
    console.log('Files directory does not exist, creating...');
    fs.mkdirSync(filesDir, { recursive: true });
  }

  // 扫描目录树
  const tree = scanDirectory(filesDir);
  
  // 扁平化并添加ID
  const { items: fileList } = flattenWithIds(tree);

  if (!fs.existsSync(apiDir)) {
    fs.mkdirSync(apiDir, { recursive: true });
  }

  // 生成文件列表的哈希值
  const content = JSON.stringify(fileList, null, 2);
  const hash = crypto.createHash('md5').update(content).digest('hex').substring(0, 8);
  
  // 写入files.json
  fs.writeFileSync(outputPath, content);
  
  // 写入manifest文件，包含版本信息
  const manifest = {
    version: hash,
    timestamp: new Date().toISOString(),
    fileCount: fileList.filter(f => f.type === 'file').length,
    folderCount: fileList.filter(f => f.type === 'folder').length,
    totalCount: fileList.length
  };
  fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
  
  console.log(`Generated file list with ${manifest.fileCount} files and ${manifest.folderCount} folders (version: ${hash})`);
}

generateFileList();
