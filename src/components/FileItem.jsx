import FileIcon from './icons/FileIcon';
import FolderIcon from './icons/FolderIcon';
import DownloadIcon from './icons/DownloadIcon';
import PreviewIcon from './icons/PreviewIcon';
import CheckIcon from './icons/CheckIcon';
import { getFileType, formatFileSize, formatDate } from '../utils/fileUtils';
import '../styles/FileItem.css';

export default function FileItem({ 
  file, 
  isSelected, 
  onSelect, 
  onDownload,
  onPreview,
  viewMode 
}) {
  const fileType = getFileType(file.name);
  
  const handleClick = (e) => {
    if (e.target.closest('.file-actions')) return;
    onSelect(file.id);
  };

  const handleDoubleClick = (e) => {
    if (e.target.closest('.file-actions')) return;
    if (onPreview) {
      onPreview(file);
    }
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
            <DownloadIcon size={16} />
          </button>
        )}
      </div>
    );
  }

  return (
    <div 
      className={`file-item-list ${isSelected ? 'selected' : ''}`}
      onClick={handleClick}
      onDoubleClick={handleDoubleClick}
    >
      <div className="file-checkbox">
        {isSelected && <CheckIcon size={16} />}
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
