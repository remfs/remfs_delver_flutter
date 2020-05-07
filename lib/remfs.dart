class RemFS {
  String type;
  Map<String, RemFS> children;

  RemFS({this.type, this.children});

  RemFS.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    children = Map();

    if (type == 'dir' && json['children'] != null) {
      json['children'].forEach((k, v) {
        RemFS newChild = RemFS.fromJson(v);
        children[k] = newChild;
      });
    }
  }

  @override
  String toString() {
    return "type: ${type}, children: ${children}";
  }
}
