class WardrobeDrawer {
  int id;
  int position;
  int wardrobeFk;

  WardrobeDrawer(this.id, this.position, this.wardrobeFk);

  WardrobeDrawer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        position = json['position'],
        wardrobeFk = json['wardrobe_fk'];
}
