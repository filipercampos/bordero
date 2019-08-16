import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bordero/models/cheque.dart';
import 'package:bordero/repository/repository_helper.dart';
import 'package:rxdart/subjects.dart';

class ChequeBloc extends BlocBase {
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  @override
  void dispose() {
    super.dispose();
    _loadingController.close();
    _createdController.close();
  }

  Future<bool> saveCheques(List<Cheque> cheques) async {
    try {
      _loadingController.add(true);

      int count = 0;
      final repository = RepositoryHelper().chequeRepository;
      for (Cheque cheque in cheques) {
        int id = await repository.insert(cheque.toJson());
        if (id != 0) {
          cheque.id = id;
          count++;
        }
      }
      repository.close();

      _createdController.add(true);

      _loadingController.add(false);
      return count == cheques.length;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  
}
