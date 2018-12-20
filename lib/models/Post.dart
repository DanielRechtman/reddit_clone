import 'package:bredditc/models/DataPost.dart';

class Post{
  final List<DataPost> posts;
  
  Post({this.posts});

  factory Post.fromJson(Map<String,dynamic> json){
    var list =json['data']['children'] as List;
    List<DataPost>  postList =  list.map((i)=> DataPost.fromJson(i)).toList();
    return Post(
      posts: postList,
      );
  }
}