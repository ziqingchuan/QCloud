export default function FileIcon({ size = 20, color = "#8B9DC3", type = "default" }) {
  const colors = {
    pdf: "#E74C3C",
    doc: "#3498DB",
    excel: "#27AE60",
    ppt: "#E67E22",
    image: "#9B59B6",
    zip: "#95A5A6",
    txt: "#34495E",
    default: "#8B9DC3"
  };
  
  const fillColor = colors[type] || colors.default;
  
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M14 2H6C4.9 2 4.01 2.9 4.01 4L4 20C4 21.1 4.89 22 5.99 22H18C19.1 22 20 21.1 20 20V8L14 2ZM6 20V4H13V9H18V20H6Z" fill={fillColor}/>
    </svg>
  );
}
