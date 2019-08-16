abstract class Dao {

  Future<int> insert(Map<String,dynamic> entity);

  Future<int> update(Map<String,dynamic> entity);

  Future<bool> delete(int id);

  Future<List<Map<String,dynamic>>> getAll();

   Future<Map<String, dynamic>> get(int id);
}