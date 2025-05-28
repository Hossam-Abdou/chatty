class UserModel {
  String? image;
  String? name;
  // String? about;
  // String? createdAt;
  String? uid;
  // String? lastActive;
  bool? isOnline;
  String? email;
  // String? pushToken;

  UserModel(
      {this.image,
        this.name,
        // this.about,
        // this.createdAt,
        this.uid,
        // this.lastActive,
        this.isOnline,
        this.email,
        // this.pushToken
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name']??'User';
    // about = json['about'];
    // createdAt = json['created_at'];
    uid = json['uid'];
    // lastActive = json['last_active'];
    isOnline = json['is_online'];
    email = json['email'];
    // pushToken = json['push_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    // data['about'] = about;
    // data['created_at'] = createdAt;
    data['uid'] = uid;
    // data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['email'] = email;
    // data['push_token'] = pushToken;
    return data;
  }
}
