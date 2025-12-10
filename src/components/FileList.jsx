import { useState, useEffect } from 'react';
import FileItem from './FileItem';
import '../styles/FileList.css';

export default function FileList({ 
  files, 
  selectedFiles,
  expandedFolders,
  onSelectFile, 
  onDownloadFile,
  onPreviewFile,
  onToggleFolder,
  viewMode 
}) {
  const [sortedFiles, setSortedFiles] = useState([]);

  useEffect(() => {
    // 直接使用文件列表，不进行排序
    // 文件列表在生成时已经按照正确的层级顺序排列
    setSortedFiles(files);
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
          <div className="header-expand"></div>
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
            isExpanded={expandedFolders.includes(file.path)}
            onSelect={onSelectFile}
            onDownload={onDownloadFile}
            onPreview={onPreviewFile}
            onToggleFolder={onToggleFolder}
            viewMode={viewMode}
          />
        ))}
      </div>
    </div>
  );
}
