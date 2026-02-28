class UserSkill {
  String? id;
  String? userid;
  String? highestQualifications;
  String? degree;
  String? university;
  String? yearGraduation;
  String? jobRole;
  String? positionLevel;
  String? workExperience;
  String? skills;

  UserSkill({
    this.id,
    this.userid,
    this.highestQualifications,
    this.degree,
    this.university,
    this.yearGraduation,
    this.jobRole,
    this.positionLevel,
    this.workExperience,
    this.skills,
  });

  UserSkill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    highestQualifications = json['highest_qualifications'];
    degree = json['degree'];
    university = json['university'];
    yearGraduation = json['year_graduation'];
    jobRole = json['job_role'];
    positionLevel = json['position_level'];
    workExperience = json['work_experience'];
    skills = json['skills'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userid'] = userid;
    data['highest_qualifications'] = highestQualifications;
    data['degree'] = degree;
    data['university'] = university;
    data['year_graduation'] = yearGraduation;
    data['job_role'] = jobRole;
    data['position_level'] = positionLevel;
    data['work_experience'] = workExperience;
    data['skills'] = skills;
    return data;
  }
}
