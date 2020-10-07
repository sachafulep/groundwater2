import "package:flutter/material.dart";
import "package:groundwater/model/data/note/note.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

typedef void SaveNoteCallback({String newNote, Note existingNote});
typedef void DeleteNoteCallback(Note note);

/// Pick Sensor dialog
class AddNoteDialog extends StatefulWidget {
  /// Pick Sensor dialog
  AddNoteDialog({Key key, this.saveNoteCallback, this.deleteNoteCallback, this.note}) : super(key: key);

  /// Page title
  final SaveNoteCallback saveNoteCallback;
  final DeleteNoteCallback deleteNoteCallback;
  final Note note;

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState(saveNoteCallback: saveNoteCallback, deleteNoteCallback: deleteNoteCallback, note: note);
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  _AddNoteDialogState({this.saveNoteCallback, this.deleteNoteCallback, this.note});

  final SaveNoteCallback saveNoteCallback;
  final DeleteNoteCallback deleteNoteCallback;
  Note note;

  final noteTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteTextController.text = note?.description ?? "";
  }

  void _saveNote() {
    Navigator.of(context).pop();
    if (note == null) {
      // Creating a new note
      saveNoteCallback(newNote: noteTextController.text);
    } else {
      // Updating an existing note
      note.description = noteTextController.text;
      saveNoteCallback(existingNote: note);
    }
  }

  void _deleteNote(){
    Navigator.of(context).pop();
    deleteNoteCallback(note);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      title: Text((note == null) ? Strings.detailsAddNoteTitle : Strings.detailsEditNoteTitle),
      contentPadding: EdgeInsets.only(left: 16, top: 16, right: 16),
      content: Container(
        width: double.maxFinite,
        child: TextField(
          controller: noteTextController,
          minLines: 6,
          maxLines: 10,
          onSubmitted: (String text) {
            _saveNote();
          },
          decoration: InputDecoration(
            filled: true,
            contentPadding: EdgeInsets.all(16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                )),
            hintText: Strings.detailsNoteHint,
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            Strings.cancel,
            style: TextStyle(color: GroundColor.subText),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        if (note != null)
          FlatButton(
            child: Text(
              Strings.delete,
              style: TextStyle(color: GroundColor.error),
            ),
            onPressed: _deleteNote,
          ),
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: FlatButton(
            child: Text(
              Strings.save,
              style: TextStyle(color: GroundColor.accent),
            ),
            onPressed: _saveNote,
          ),
        ),
      ],
    );
  }
}
