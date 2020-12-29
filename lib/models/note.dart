class Note {
  int noteID;
  int categoryID;
  String categoryName;
  String noteName;
  String noteContent;
  String noteDate;
  int notePriority;

  Note(this.categoryID, this.noteName, this.noteContent, this.noteDate,
      this.notePriority); //verileri yazarken

  Note.withID(this.noteID, this.categoryID, this.noteName, this.noteContent,
      this.noteDate, this.notePriority); //verileri okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['noteID'] = noteID;
    map['categoryID'] = categoryID;
    map['noteName'] = noteName;
    map['noteContent'] = noteContent;
    map['noteDate'] = noteDate;
    map['notePriority'] = notePriority;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this.noteID = map[
        'noteID']; //bu sınıftaki noteIDye parametre olarak gelen map'in noteIDsini koy
    this.categoryID = map['categoryID'];
    this.categoryName = map['categoryName'];
    this.noteName = map['noteName'];
    this.noteContent = map['noteContent'];
    this.noteDate = map['noteDate'];
    this.notePriority = map['notePriority'];
  }

  @override
  String toString() {
    return 'Note{noteID: $noteID, categoryID: $categoryID, noteName: $noteName, noteContent: $noteContent, noteDate: $noteDate, notePriority: $notePriority}';
  }
}
