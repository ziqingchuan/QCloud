import { useState, useEffect } from 'react';
import FileIcon from './icons/FileIcon';
import FolderIcon from './icons/FolderIcon';
import DownloadIcon from './icons/DownloadIcon';
import CopyIcon from './icons/CopyIcon';
import { getFileType, formatFileSize, formatDate } from '../utils/fileUtils';
import '../styles/SplitView.css';

export default function SplitView({ files, onDownloadFile }) {
  const [selectedFile, setSelectedFile] = useState(null);
  const [content, setContent] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(false);
  const [showCopySuccess, setShowCopySuccess] = useState(false);

  useEffect(() => {
    if (files.length > 0 && !selectedFile) {
      setSelectedFile(files[0]);
    }
  }, [files]);

  useEffect(() => {
    if (selectedFile) {
      loadFileContent();
    }
  }, [selectedFile]);

  const loadFileContent = async () => {
    if (!selectedFile) return;
    
    setLoading(true);
    setError(false);
    
    try {
      const basePath = import.meta.env.BASE_URL || '/';
      const ext = selectedFile.name.split('.').pop().toLowerCase();
      const textExtensions = ['txt', 'md', 'html', 'css', 'js', 'json', 'xml', 'csv', 'log', 'jsx', 'ts', 'tsx', 'doc', 'docx'];
      const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp'];
      
      if (ext === 'pdf') {
        setContent(`${basePath}files/${selectedFile.name}`);
      } else if (textExtensions.includes(ext)) {
        const response = await fetch(`${basePath}files/${selectedFile.name}`);
        const blob = await response.blob();
        const text = await blob.text();
        setContent(text);
      } else if (imageExtensions.includes(ext)) {
        setContent(`${basePath}files/${selectedFile.name}`);
      } else {
        setContent('preview-not-supported');
      }
    } catch (err) {
      console.error('Error loading file:', err);
      setError(true);
    } finally {
      setLoading(false);
    }
  };

  const getFileTypeCategory = (file) => {
    const ext = file.name.split('.').pop().toLowerCase();
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp'];
    const textExtensions = ['txt', 'md', 'html', 'css', 'js', 'json', 'xml', 'csv', 'log', 'jsx', 'ts', 'tsx', 'doc', 'docx'];
    
    if (ext === 'pdf') return 'pdf';
    if (imageExtensions.includes(ext)) return 'image';
    if (textExtensions.includes(ext)) return 'text';
    return 'other';
  };

  const handleCopyContent = async () => {
    try {
      await navigator.clipboard.writeText(content);
      setShowCopySuccess(true);
      setTimeout(() => {
        setShowCopySuccess(false);
      }, 2000);
    } catch (err) {
      console.error('Failed to copy:', err);
    }
  };

  const renderContent = () => {
    if (!selectedFile) {
      return (
        <div className="split-empty">
          <p>请从左侧选择文件进行预览</p>
        </div>
      );
    }

    if (loading) {
      return <div className="split-loading">加载中...</div>;
    }

    if (error) {
      return <div className="split-error">加载失败</div>;
    }

    const fileType = getFileTypeCategory(selectedFile);

    if (fileType === 'pdf') {
      return (
        <div className="split-pdf-container">
          <iframe
            src={content}
            className="split-pdf"
            title={selectedFile.name}
          />
        </div>
      );
    }

    if (fileType === 'image') {
      return (
        <div className="split-image-container">
          <img src={content} alt={selectedFile.name} className="split-image" />
        </div>
      );
    }

    if (fileType === 'text') {
      return (
        <div className="split-text-wrapper">
          <button 
            className="btn-copy-split" 
            onClick={handleCopyContent}
            title="复制内容"
          >
            {showCopySuccess ? (
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path d="M9 16.17L4.83 12L3.41 13.41L9 19L21 7L19.59 5.59L9 16.17Z" fill="#34A853"/>
              </svg>
            ) : (
              <CopyIcon size={20} />
            )}
          </button>
          <pre className="split-text">
            <code>{content}</code>
          </pre>
        </div>
      );
    }

    return (
      <div className="split-not-supported">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none">
          <path d="M14 2H6C4.9 2 4.01 2.9 4.01 4L4 20C4 21.1 4.89 22 5.99 22H18C19.1 22 20 21.1 20 20V8L14 2ZM6 20V4H13V9H18V20H6Z" fill="#8B9DC3"/>
        </svg>
        <p>此文件类型不支持预览</p>
        <p className="split-hint">请下载后查看</p>
      </div>
    );
  };

  return (
    <div className="split-view">
      <div className="split-sidebar">
        <div className="split-sidebar-header">
          <h3>文件列表</h3>
        </div>
        <div className="split-file-list">
          {files.map(file => {
            const fileType = getFileType(file.name);
            const isSelected = selectedFile?.id === file.id;
            
            return (
              <div
                key={file.id}
                className={`split-file-item ${isSelected ? 'selected' : ''}`}
                onClick={() => setSelectedFile(file)}
              >
                <div className="split-file-icon">
                  {file.type === 'folder' ? (
                    <FolderIcon size={20} />
                  ) : (
                    <FileIcon size={20} type={fileType} />
                  )}
                </div>
                <div className="split-file-info">
                  <div className="split-file-name" title={file.name}>
                    {file.name}
                  </div>
                  <div className="split-file-meta">
                    {formatFileSize(file.size)}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      <div className="split-content">
        {selectedFile && (
          <div className="split-content-header">
            <div className="split-content-info">
              <h2>{selectedFile.name}</h2>
              <div className="split-content-meta">
                <span>{formatFileSize(selectedFile.size)}</span>
                <span>•</span>
                <span>{formatDate(selectedFile.modifiedDate)}</span>
              </div>
            </div>
            <button 
              className="btn-split-download"
              onClick={() => onDownloadFile(selectedFile)}
              title="下载"
            >
              <DownloadIcon size={18} color="#fff" />
              <span>下载</span>
            </button>
          </div>
        )}
        <div className="split-content-body">
          {renderContent()}
        </div>
      </div>
    </div>
  );
}
