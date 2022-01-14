class Service {
  String? id;
  String prix;
  String nom;
  String? idComp;
  String? idType;
  String ?code;
  String ?duree;
  int count;

  Service(
      {this.code,
       this.nom = '',
      this.idComp,
      this.idType,
       this.prix = "0",
      this.id,
      this.duree,
      this.count = 0});
  int compareTo(Service other) {
    if (this.count < other.count) return 1;
    if (this.count > other.count) return -1;
    return 0;
  }

  void checkNull() {
    String s = "";
    s += code == null
        ? "code_null"
        : "" + nom == null
            ? "nome_null"
            : "" + prix == null
                ? "prix_null"
                : "";
    print("---------------------");
    print(s);
    print("---------------------");
  }
}

class TypeService {
  String id;
  String nom;
  String idComp;
  TypeService({required this.nom,  this.idComp ='',required  this.id});
}
