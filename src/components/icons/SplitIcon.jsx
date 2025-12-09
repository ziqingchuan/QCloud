export default function SplitIcon({ size = 20, color = "#5F6368" }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M3 3H11V21H3V3ZM13 3H21V21H13V3Z" fill={color}/>
    </svg>
  );
}
