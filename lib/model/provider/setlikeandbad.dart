import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class LikeAndBadCountProvider extends ChangeNotifier {

  List<XFile>? images = [];




  void setImages(List<XFile>? img) async {
    print('imges===================== setImages pass }');
    // if(img != null){
    //   for(var v in img){
    //     images!.add(v);
    //   }
    // }

    images = img;
    notifyListeners();
  }

  void cancel() {
    images = null;
    notifyListeners();
  }

  void chooseMainIcon() {

  }



}

//  } else {
//           returnList.add('not approved');
//         }
//       }else{
//         returnList.add('state err');
//       }
//     }catch(e){
//       returnList.add('server connect fail');
//     }
// class SaveContentProvider extends ChangeNotifier{
//
//   final Set<MainContentDataModel> _saved = <MainContentDataModel>{};
//
//   void toggleSaved(MainContentDataModel newSaved){
//     print('toggle pass');
//     final bool alreadySaved = _saved.contains(newSaved);
//     print('있냐 없냐 $alreadySaved');
//     if (alreadySaved) {
//       _saved.remove(newSaved);
//     } else {
//       _saved.add(newSaved);
//     }
//     notifyListeners();//노티파이어 위젯에게 변경된 데이터 알려줌 setstate?같은거
//   }
//
//   /////////////
//   //Set<WordPair> get saved => _saved;
//   Set<WordPair> get saved {
//     print('아랫것이랑 같은 것');
//     return _saved;
//   }
//
//
//
//   //이거랑 같은거
//   Set<WordPair> getSaved(){
//
//     return _saved;
//   }
//   //애랑 같은데 ()만 없는거 있는거 차이임
// ////////////
//   //두메소는 같은거임 //!!
//   bool alreadyContain(WordPair wordPair){
//     return _saved.contains(wordPair);
//   }
//
// }
//앱바 불들어오게 만들것
