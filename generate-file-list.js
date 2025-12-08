import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const filesDir = path.join(__dirname, 'public', 'files');
const outputPath = path.join(__dirname, 'public', 'api', 'files.json');

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

  const apiDir = path.join(__dirname, 'public', 'api');
  if (!fs.existsSync(apiDir)) {
    fs.mkdirSync(apiDir, { recursive: true });
  }

  fs.writeFileSync(outputPath, JSON.stringify(fileList, null, 2));
  console.log(`Generated file list with ${fileList.length} files`);
}

generateFileList();
