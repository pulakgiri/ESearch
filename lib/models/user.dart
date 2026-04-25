class User {
  String? id;
  String? userid;
  String? image;
  String? email;
  String? mobileno;
  String? fullname;
  String? password;
  String? dob;
  String? cv;

  User({
    this.id,
    this.userid,
    this.image,
    this.email,
    this.mobileno,
    this.fullname,
    this.password,
    this.dob,
    this.cv,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    image = json['profile_image'];
    email = json['email'];
    mobileno = json['mobileno'];
    fullname = json['fullname'];
    password = json['password'];
    dob = json['dob'];
    cv = json['cv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['profile_image'] = this.image;
    data['email'] = this.email;
    data['mobileno'] = this.mobileno;
    data['fullname'] = this.fullname;
    data['password'] = this.password;
    data['dob'] = this.dob;
    data['cv'] = this.cv;

    return data;
  }
}
