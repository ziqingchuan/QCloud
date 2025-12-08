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

function generateFileList() {
  if (!fs.existsSync(filesDir)) {
    console.log('Files directory does not exist, creating...');
    fs.mkdirSync(filesDir, { recursive: true });
  }

  const files = fs.readdirSync(filesDir);
  const fileList = files
    .filter(filename => {
      const filePath = path.join(filesDir, filename);
      return fs.statSync(filePath).isFile();
    })
    .map((filename, index) => {
      const filePath = path.join(filesDir, filename);
      const stats = fs.statSync(filePath);
      
      return {
        id: index + 1,
        name: filename,
        type: 'file',
        size: stats.size,
        modifiedDate: stats.mtime.toISOString()
      };
    });

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
    fileCount: fileList.length
  };
  fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
  
  console.log(`Generated file list with ${fileList.length} files (version: ${hash})`);
}

generateFileList();
