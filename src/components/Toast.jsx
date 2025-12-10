import { useEffect } from 'react';
import '../styles/Toast.css';

export default function Toast({ message, type = 'success', isVisible, onClose }) {
  useEffect(() => {
    if (isVisible) {
      const timer = setTimeout(() => {
        onClose();
      }, 2000);
      return () => clearTimeout(timer);
    }
  }, [isVisible, onClose]);

  if (!isVisible) return null;

  const getIcon = () => {
    if (type === 'success') {
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" fill="#4CAF50"/>
          <path d="M9 12L11 14L15 10" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      );
    }
    if (type === 'error') {
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" fill="#F44336"/>
          <path d="M15 9L9 15M9 9L15 15" stroke="white" strokeWidth="2" strokeLinecap="round"/>
        </svg>
      );
    }
    if (type === 'info') {
      return (
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" fill="#2196F3"/>
          <path d="M12 16V12M12 8H12.01" stroke="white" strokeWidth="2" strokeLinecap="round"/>
        </svg>
      );
    }
  };

  return (
    <div className={`toast toast-${type}`}>
      {getIcon()}
      <span>{message}</span>
    </div>
  );
}
