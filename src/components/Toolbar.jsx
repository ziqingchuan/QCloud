import { useState } from 'react';
import SearchIcon from './icons/SearchIcon';
import DownloadIcon from './icons/DownloadIcon';
import GridIcon from './icons/GridIcon';
import ListIcon from './icons/ListIcon';
import SplitIcon from './icons/SplitIcon';
import '../styles/Toolbar.css';

export default function Toolbar({ 
  onSearch, 
  onDownloadSelected, 
  selectedCount,
  viewMode,
  onViewModeChange 
}) {
  const [searchText, setSearchText] = useState('');

  const handleSearch = (e) => {
    const value = e.target.value;
    setSearchText(value);
    onSearch(value);
  };

  return (
    <div className="toolbar">
      <div className="toolbar-left">
        <div className="search-box">
          <SearchIcon size={18} />
          <input
            type="text"
            placeholder="搜索文件"
            value={searchText}
            onChange={handleSearch}
          />
        </div>
      </div>
      
      <div className="toolbar-right">
        {selectedCount > 0 && (
          <button className="btn-download" onClick={onDownloadSelected}>
            <DownloadIcon size={18} color="#fff" />
            <span>批量下载 ({selectedCount})</span>
          </button>
        )}
        
        <div className="view-toggle">
          <button 
            className={viewMode === 'list' ? 'active' : ''}
            onClick={() => onViewModeChange('list')}
            title="列表视图"
          >
            <ListIcon size={20} color={viewMode === 'list' ? '#1A73E8' : '#5F6368'} />
          </button>
          <button 
            className={viewMode === 'grid' ? 'active' : ''}
            onClick={() => onViewModeChange('grid')}
            title="网格视图"
          >
            <GridIcon size={20} color={viewMode === 'grid' ? '#1A73E8' : '#5F6368'} />
          </button>
          <button 
            className={viewMode === 'split' ? 'active' : ''}
            onClick={() => onViewModeChange('split')}
            title="分栏视图"
          >
            <SplitIcon size={20} color={viewMode === 'split' ? '#1A73E8' : '#5F6368'} />
          </button>
        </div>
      </div>
    </div>
  );
}
