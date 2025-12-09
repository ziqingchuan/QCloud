import { useState, useEffect } from 'react';
import Toolbar from './components/Toolbar';
import FileList from './components/FileList';
import SplitView from './components/SplitView';
import FileViewer from './components/FileViewer';
import Toast from './components/Toast';
import './styles/App.css';

function App() {
  const [files, setFiles] = useState([]);
  const [filteredFiles, setFilteredFiles] = useState([]);
  const [selectedFiles, setSelectedFiles] = useState([]);
  const [viewMode, setViewMode] = useState('list');
  const [previewFile, setPreviewFile] = useState(null);
  const [toast, setToast] = useState({ isVisible: false, message: '', type: 'success' });

  useEffect(() => {
    loadFiles();
  }, []);

  const loadFiles = async () => {
    try {
      const fileList = await scanFilesDirectory();
      setFiles(fileList);
      setFilteredFiles(fileList);
    } catch (error) {
      console.error('Error loading files:', error);
      showToast('加载文件失败', 'error');
    }
  };

  const scanFilesDirectory = async () => {
    try {
      const basePath = import.meta.env.BASE_URL || '/';
      
      // 先获取manifest获取版本号
      let version = new Date().getTime();
      try {
        const manifestModule = await import('./file-manifest.json');
        version = manifestModule.default.version || version;
      } catch (e) {
        console.log('No manifest found, using timestamp');
      }
      
      const response = await fetch(`${basePath}api/files.json?v=${version}`, {
        cache: 'no-cache',
        headers: {
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache'
        }
      });
      if (response.ok) {
        const fileList = await response.json();
        return fileList;
      }
    } catch (error) {
      console.error('Failed to load files:', error);
    }
    
    return [];
  };

  const showToast = (message, type = 'success') => {
    setToast({ isVisible: true, message, type });
  };

  const closeToast = () => {
    setToast({ isVisible: false, message: '', type: 'success' });
  };

  const handleSearch = (searchText) => {
    if (!searchText.trim()) {
      setFilteredFiles(files);
      return;
    }
    const filtered = files.filter(file => 
      file.name.toLowerCase().includes(searchText.toLowerCase())
    );
    setFilteredFiles(filtered);
  };

  const handleSelectFile = (fileId) => {
    setSelectedFiles(prev => {
      if (prev.includes(fileId)) {
        return prev.filter(id => id !== fileId);
      }
      return [...prev, fileId];
    });
  };

  const handlePreviewFile = (file) => {
    setPreviewFile(file);
  };

  const handleClosePreview = () => {
    setPreviewFile(null);
  };

  const handleDownloadFile = (file) => {
    try {
      const basePath = import.meta.env.BASE_URL || '/';
      const link = document.createElement('a');
      link.href = `${basePath}files/${file.name}`;
      link.download = file.name;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      
      showToast(`下载成功: ${file.name}`, 'success');
    } catch (error) {
      showToast(`下载失败: ${file.name}`, 'error');
    }
  };

  const handleDownloadSelected = async () => {
    const selectedFileList = files.filter(f => selectedFiles.includes(f.id));
    
    if (selectedFileList.length === 0) return;

    if (selectedFileList.length === 1) {
      handleDownloadFile(selectedFileList[0]);
      return;
    }

    try {
      showToast(`正在下载 ${selectedFileList.length} 个文件...`, 'info');
      
      const basePath = import.meta.env.BASE_URL || '/';
      for (const file of selectedFileList) {
        await new Promise(resolve => setTimeout(resolve, 300));
        const link = document.createElement('a');
        link.href = `${basePath}files/${file.name}`;
        link.download = file.name;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      }
      
      setTimeout(() => {
        showToast(`批量下载完成 (${selectedFileList.length} 个文件)`, 'success');
      }, 500);
    } catch (error) {
      showToast('批量下载失败', 'error');
    }
  };

  return (
    <div className="app">
      <header className="app-header">
        <div className='logo-container'>
          <svg t="1765169716364" viewBox="0 0 1146 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="8844" width="30" height="30"><path d="M733.696 424.96c-7.68 0-14.848 0.512-22.528 1.024-48.64-104.96-152.064-177.664-271.872-177.664-156.672 0-285.184 124.416-300.032 283.136C60.416 550.912 2.048 624.128 2.048 712.192c0 102.4 79.872 185.344 178.176 185.344h536.064v-1.536c5.632 0.512 11.776 0.512 17.408 0.512 125.44 0 226.304-105.472 226.304-236.032 0-129.536-101.376-235.52-226.304-235.52z" fill="#5FA1FC" p-id="8845"></path><path d="M961.536 279.04c-6.144 0-12.288 0.512-18.432 1.024-39.936-85.504-123.392-144.384-220.672-144.384-69.12 0-131.072 29.696-175.616 77.824 81.408 27.136 150.016 84.48 194.048 159.232 148.48 3.584 267.776 129.024 270.336 283.648 77.824-22.528 135.168-96.768 135.168-184.832-0.512-106.496-83.456-192.512-184.832-192.512z" fill="#88B8FD" p-id="8846"></path></svg>
          <h1>QCloud</h1>
        </div>
      </header>
      
      <main className="app-main">
        <Toolbar
          onSearch={handleSearch}
          onDownloadSelected={handleDownloadSelected}
          selectedCount={selectedFiles.length}
          viewMode={viewMode}
          onViewModeChange={setViewMode}
        />
        
        {viewMode === 'split' ? (
          <SplitView
            files={filteredFiles}
            onDownloadFile={handleDownloadFile}
          />
        ) : (
          <FileList
            files={filteredFiles}
            selectedFiles={selectedFiles}
            onSelectFile={handleSelectFile}
            onDownloadFile={handleDownloadFile}
            onPreviewFile={handlePreviewFile}
            viewMode={viewMode}
          />
        )}
      </main>

      {previewFile && (
        <FileViewer
          file={previewFile}
          onDownload={handleDownloadFile}
          onClose={handleClosePreview}
        />
      )}

      <Toast
        message={toast.message}
        type={toast.type}
        isVisible={toast.isVisible}
        onClose={closeToast}
      />
    </div>
  );
}

export default App;
