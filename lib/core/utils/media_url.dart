String resolveMediaUrl(String? url) {
  if (url == null) return "";
  final u = url.trim();
  if (u.isEmpty) return "";
  return u.replaceFirst("http://localhost:5000", "http://10.0.2.2:5000");
}