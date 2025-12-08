import { useState, useEffect } from 'react';
import FileItem from './FileItem';
import '../styles/FileList.css';

export default function FileList({ 
  files, 
  selectedFiles, 
  onSelectFile, 
  onDownloadFile,
  onPreviewFile,
  viewMode 
}) {
  const [sortedFiles, setSortedFiles] = useState([]);

  useEffect(() => {
    const sorted = [...files].sort((a, b) => {
      if (a.type === 'folder' && b.type !== 'folder') return -1;
      if (a.type !== 'folder' && b.type === 'folder') return 1;
      return a.name.localeCompare(b.name);
    });
    setSortedFiles(sorted);
  }, [files]);

  if (sortedFiles.length === 0) {
    return (
      <div className="empty-state">
        <p>暂无文件</p>
      </div>
    );
  }

  return (
    <div className={`file-list ${viewMode}`}>
      {viewMode === 'list' && (
        <div className="file-list-header">
          <div className="header-checkbox"></div>
          <div className="header-icon"></div>
          <div className="header-name">名称</div>
          <div className="header-size header-center">大小</div>
          <div className="header-date header-center">修改日期</div>
          <div className="header-actions header-center">操作</div>
        </div>
      )}
      
      <div className="file-list-content">
        {sortedFiles.map(file => (
          <FileItem
            key={file.id}
            file={file}
            isSelected={selectedFiles.includes(file.id)}
            onSelect={onSelectFile}
            onDownload={onDownloadFile}
            onPreview={onPreviewFile}
            viewMode={viewMode}
          />
        ))}
      </div>
    </div>
  );
}
