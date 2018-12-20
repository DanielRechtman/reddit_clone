class DataPost{
  final String title;
  
  DataPost({this.title});

  factory DataPost.fromJson(Map<String,dynamic> json){
    return DataPost(title: json['data']['title']);
  }
}