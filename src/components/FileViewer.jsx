import { useState, useEffect } from 'react';
import DownloadIcon from './icons/DownloadIcon';
import CopyIcon from './icons/CopyIcon';
import { formatFileSize } from '../utils/fileUtils';
import '../styles/FileViewer.css';

export default function FileViewer({ file, onDownload, onClose }) {
  const [content, setContent] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const [showCopySuccess, setShowCopySuccess] = useState(false);

  useEffect(() => {
    if (file) {
      loadFileContent();
    }
  }, [file]);

  const loadFileContent = async () => {
    setLoading(true);
    setError(false);
    
    try {
      const basePath = import.meta.env.BASE_URL || '/';
      const ext = file.name.split('.').pop().toLowerCase();
      const textExtensions = ['txt', 'md', 'html', 'css', 'js', 'json', 'xml', 'csv', 'log', 'jsx', 'ts', 'tsx', 'doc', 'docx'];
      const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp'];
      
      if (ext === 'pdf') {
        setContent(`${basePath}files/${file.name}`);
      } else if (textExtensions.includes(ext)) {
        const response = await fetch(`${basePath}files/${file.name}`);
        const blob = await response.blob();
        const text = await blob.text();
        setContent(text);
      } else if (imageExtensions.includes(ext)) {
        setContent(`${basePath}files/${file.name}`);
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

  const getFileType = () => {
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
    if (loading) {
      return <div className="viewer-loading">加载中...</div>;
    }

    if (error) {
      return <div className="viewer-error">加载失败</div>;
    }

    const fileType = getFileType();

    if (fileType === 'pdf') {
      return (
        <div className="viewer-pdf-container">
          <iframe
            src={content}
            className="viewer-pdf"
            title={file.name}
          />
        </div>
      );
    }

    if (fileType === 'image') {
      return (
        <div className="viewer-image-container">
          <img src={content} alt={file.name} className="viewer-image" />
        </div>
      );
    }

    if (fileType === 'text') {
      return (
        <div className="viewer-text-wrapper">
          <button 
            className="btn-copy-content" 
            onClick={handleCopyContent}
            title="复制内容"
          >
            {showCopySuccess ? (
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none">
                <path d="M9 16.17L4.83 12L3.41 13.41L9 19L21 7L19.59 5.59L9 16.17Z" fill="#34A853"/>
              </svg>
            ) : (
              <CopyIcon size={15} />
            )}
          </button>
          <pre className="viewer-text">
            <code>{content}</code>
          </pre>
        </div>
      );
    }

    return (
      <div className="viewer-not-supported">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none">
          <path d="M14 2H6C4.9 2 4.01 2.9 4.01 4L4 20C4 21.1 4.89 22 5.99 22H18C19.1 22 20 21.1 20 20V8L14 2ZM6 20V4H13V9H18V20H6Z" fill="#8B9DC3"/>
        </svg>
        <p>此文件类型不支持预览</p>
        <p className="viewer-hint">请下载后查看</p>
      </div>
    );
  };

  if (!file) return null;

  return (
    <div className="file-viewer" onClick={onClose}>
      <div className="file-viewer-container" onClick={(e) => e.stopPropagation()}>
        <div className="viewer-header">
          <div className="viewer-info">
            <h2>{file.name}</h2>
            <span className="viewer-size">{formatFileSize(file.size)}</span>
          </div>
          <div className="viewer-actions">
            <button className="btn-viewer-download" onClick={() => onDownload(file)}>
              <DownloadIcon size={18} color="#fff" />
              <span>下载</span>
            </button>
            <button className="btn-viewer-close" onClick={onClose}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path d="M19 6.41L17.59 5L12 10.59L6.41 5L5 6.41L10.59 12L5 17.59L6.41 19L12 13.41L17.59 19L19 17.59L13.41 12L19 6.41Z" fill="#5F6368"/>
              </svg>
            </button>
          </div>
        </div>
        <div className="viewer-content">
          {renderContent()}
        </div>
      </div>
    </div>
  );
}
