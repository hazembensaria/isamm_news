
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isamm_news/features/authentication/models/user.dart';

class CurrentUserNotifier extends StateNotifier<CurrentUser?> {
  CurrentUserNotifier() : super(CurrentUser(name: "", age: 0, role: "", email: '', address: '', job: '', phone: '' , interests: [])){
    _loadUser();
    print('load from local storagggggggggeeeeee !!!!!!');
  }
final storage = GetStorage();

  // set setCurrentUser(CurrentUser user) => {state = user};

   setCurrentUser(CurrentUser currentUser) async{
    state = currentUser;
    print(
        "this is the new user state ====================================================>");
    print(state);
  }

    void setMailAndName(String name, String email) {
    state = CurrentUser(
      name: name,
      age: state!.age, // Keep the existing age
      role: state!.role, // Keep the existing role
      email: email,
      address: state!.address, // Keep the existing address
      job: state!.job, // Keep the existing job
      phone: state!.phone, // Keep the existing phone
      interests: state!.interests, // Keep the existing interests
    );
  }
    void setPersonalInfo(int age , String phone , String job , String address) {
    state = CurrentUser(
      name: state!.name,
      age: age ,// Keep the existing age
      role: state!.role, // Keep the existing role
      email: state!.email,
      address: address, // Keep the existing address
      job: job, // Keep the existing job
      phone: phone, // Keep the existing phone
      interests: state!.interests, // Keep the existing interests
    );
  }
   void setInterests(List<String> interests) {
    state = CurrentUser(
      name: state!.name,
      age: state!.age ,// Keep the existing age
      role: state!.role, // Keep the existing role
      email: state!.email,
      address: state!.address, // Keep the existing address
      job: state!.job, // Keep the existing job
      phone: state!.phone, // Keep the existing phone
      interests: interests, // Keep the existing interests
    );
  }


// Retrieve User
  Future<void> _loadUser() async {
    final json = storage.read<Map<String, dynamic>>('user');
    if (json != null) {
      state = CurrentUser.fromJson(json);
    }
  }


    Future<void> saveUser(CurrentUser user) async {
    storage.write('user', user.toJson());
  }


}

final userProvider = StateNotifierProvider<CurrentUserNotifier, CurrentUser?>(
    (ref) => CurrentUserNotifier());
