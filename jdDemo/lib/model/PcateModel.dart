/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-10-23 10:29:48
 * @LastEditors: wg
 * @LastEditTime: 2020-10-23 10:51:31
 */
class PcateModel {
  List<PcateItemModel> result;

  PcateModel({this.result});

  PcateModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<PcateItemModel>();
      json['result'].forEach((v) {
        result.add(new PcateItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PcateItemModel {
  String sId;
  String title;
  Object status;
  String pic;
  String pid;
  String sort;

  PcateItemModel(
      {this.sId, this.title, this.status, this.pic, this.pid, this.sort});

  PcateItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    status = json['status'];
    pic = json['pic'];
    pid = json['pid'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['status'] = this.status;
    data['pic'] = this.pic;
    data['pid'] = this.pid;
    data['sort'] = this.sort;
    return data;
  }
}
