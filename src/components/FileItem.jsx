import FileIcon from './icons/FileIcon';
import FolderIcon from './icons/FolderIcon';
import DownloadIcon from './icons/DownloadIcon';
import PreviewIcon from './icons/PreviewIcon';
import CheckIcon from './icons/CheckIcon';
import ChevronRightIcon from './icons/ChevronRightIcon';
import ChevronDownIcon from './icons/ChevronDownIcon';
import { getFileType, formatFileSize, formatDate } from '../utils/fileUtils';
import '../styles/FileItem.css';

export default function FileItem({ 
  file, 
  isSelected, 
  isExpanded,
  onSelect, 
  onDownload,
  onPreview,
  onToggleFolder,
  viewMode 
}) {
  const fileType = getFileType(file.name);
  const depth = file.parentPath ? file.parentPath.split('/').length : 0;
  
  const handleClick = (e) => {
    if (e.target.closest('.file-actions')) return;
    if (e.target.closest('.folder-toggle')) return;
    
    if (file.type === 'folder') {
      onToggleFolder(file.path);
    } else {
      onSelect(file.id);
    }
  };

  const handleDoubleClick = (e) => {
    if (e.target.closest('.file-actions')) return;
    if (file.type === 'folder') return;
    if (onPreview) {
      onPreview(file);
    }
  };

  const handleToggle = (e) => {
    e.stopPropagation();
    onToggleFolder(file.path);
  };

  if (viewMode === 'grid') {
    return (
      <div 
        className={`file-item-grid ${isSelected ? 'selected' : ''}`}
        onClick={handleClick}
        onDoubleClick={handleDoubleClick}
      >
        <div className="file-checkbox">
          {isSelected && <CheckIcon size={16} />}
        </div>
        <div className="file-icon-large">
          {file.type === 'folder' ? (
            <FolderIcon size={48} />
          ) : (
            <FileIcon size={48} type={fileType} />
          )}
        </div>
        <div className="file-name" title={file.name}>{file.name}</div>
        <div className="file-size">{formatFileSize(file.size)}</div>
        {file.type !== 'folder' && (
          <button 
            className="file-download-btn"
            onClick={(e) => {
              e.stopPropagation();
              onDownload(file);
            }}
          >
            <DownloadIcon size={12} />
          </button>
        )}
      </div>
    );
  }

  return (
    <div 
      className={`file-item-list ${isSelected ? 'selected' : ''} ${file.type === 'folder' ? 'folder' : ''}`}
      onClick={handleClick}
      onDoubleClick={handleDoubleClick}
      style={{ paddingLeft: `${16 + depth * 24}px` }}
    >
      <div className="file-expand">
        {file.type === 'folder' && file.hasChildren ? (
          <button className="folder-toggle" onClick={handleToggle}>
            {isExpanded ? (
              <ChevronDownIcon size={16} />
            ) : (
              <ChevronRightIcon size={16} />
            )}
          </button>
        ) : (
          <span className="folder-spacer"></span>
        )}
      </div>
      
      <div className="file-checkbox">
        {isSelected && file.type !== 'folder' && <CheckIcon size={16} />}
      </div>
      
      <div className="file-icon">
        {file.type === 'folder' ? (
          <FolderIcon size={24} />
        ) : (
          <FileIcon size={24} type={fileType} />
        )}
      </div>
      
      <div className="file-info">
        <div className="file-name">{file.name}</div>
      </div>
      
      <div className="file-size">{formatFileSize(file.size)}</div>
      
      <div className="file-date">{formatDate(file.modifiedDate)}</div>
      
      <div className="file-actions">
        {file.type !== 'folder' && (
          <>
            <button 
              className="btn-icon"
              onClick={(e) => {
                e.stopPropagation();
                if (onPreview) {
                  onPreview(file);
                }
              }}
              title="预览"
            >
              <PreviewIcon size={18} />
            </button>
            <button 
              className="btn-icon"
              onClick={(e) => {
                e.stopPropagation();
                onDownload(file);
              }}
              title="下载"
            >
              <DownloadIcon size={18} />
            </button>
          </>
        )}
      </div>
    </div>
  );
}
