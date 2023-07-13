import 'package:aviator_predictor_admin/services/firestore.dart';
import 'package:aviator_predictor_admin/services/toasting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputPredictionSequenceScreen extends StatefulWidget {
  InputPredictionSequenceScreen({Key? key}) : super(key: UniqueKey());

  @override
  State<InputPredictionSequenceScreen> createState() =>
      _InputPredictionSequenceScreenState();
}

class _InputPredictionSequenceScreenState
    extends State<InputPredictionSequenceScreen>
    with SingleTickerProviderStateMixin {
  late GlobalKey<FormState> _form1Key, _form2Key;
  late TextEditingController _luckyJetController, _aviatorController;
  late FocusNode luckyJetFocusNode, aviatorFocusNode;
  CollectionReference luckyJetSequence =
      FirebaseFirestore.instance.collection('lucky-jet');
  CollectionReference aviatorSequence =
  FirebaseFirestore.instance.collection('aviator');

  @override
  void initState() {
    super.initState();
    _form1Key = GlobalKey<FormState>();
    _form2Key = GlobalKey<FormState>();
    _luckyJetController = TextEditingController();
    _aviatorController = TextEditingController();
    luckyJetFocusNode = FocusNode();
    aviatorFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Prediction Sequence"),
        elevation: 5,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form1Key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Lucky Jet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Add new sequence",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _luckyJetController,
                                focusNode: luckyJetFocusNode,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  labelText: "Enter number",
                                  isDense: true,
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return "Please enter number";
                                  } else if (double.tryParse(value!) == null) {
                                    return "Please enter valid number";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF67DF65),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  luckyJetFocusNode.unfocus();
                                  aviatorFocusNode.unfocus();
                                  if (_form1Key.currentState?.validate() ??
                                      false) {
                                    final newValue = double.tryParse(
                                            _luckyJetController.text) ??
                                        0.0;
                                    luckyJetSequence
                                        .add({
                                          'seq': newValue,
                                          'timestamp': DateTime.now()
                                        })
                                        .then((value) => showToast(
                                              context,
                                              text:
                                                  "Sequence added successfully.",
                                            ))
                                        .catchError((error) => showErrorToast(
                                              context,
                                              text:
                                                  "Sequence couldn't be added.",
                                            ));
                                    _luckyJetController.text = "";
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    "SUBMIT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "History",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot<Object?>>(
                              stream: luckyJetSequence
                                  .orderBy('timestamp')
                                  .limitToLast(10)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot<Object?>>
                                      snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Something went wrong");
                                }
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                final data = snapshot.requireData.docs
                                    .map((e) => Sequence.fromJson(
                                            e.data() as Map<String, dynamic>)
                                        .seq)
                                    .toList();
                                return Text(
                                  data.isEmpty ? "--" : data.join("\n"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14.0),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 80,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  luckyJetSequence.get().then((snapshot) {
                                    for (DocumentSnapshot doc
                                        in snapshot.docs) {
                                      doc.reference.delete();
                                    }
                                  });
                                },
                                child: const Center(
                                  child: Text(
                                    "Clear",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form2Key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Aviator",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Add new sequence",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _aviatorController,
                                focusNode: aviatorFocusNode,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  labelText: "Enter number",
                                  isDense: true,
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return "Please enter number";
                                  } else if (double.tryParse(value!) == null) {
                                    return "Please enter valid number";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF67DF65),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  luckyJetFocusNode.unfocus();
                                  aviatorFocusNode.unfocus();
                                  if (_form2Key.currentState?.validate() ??
                                      false) {
                                    final newValue = double.tryParse(
                                            _aviatorController.text) ??
                                        0.0;
                                    aviatorSequence
                                        .add({
                                      'seq': newValue,
                                      'timestamp': DateTime.now()
                                    })
                                        .then((value) => showToast(
                                      context,
                                      text:
                                      "Sequence added successfully.",
                                    ))
                                        .catchError((error) => showErrorToast(
                                      context,
                                      text:
                                      "Sequence couldn't be added.",
                                    ));
                                    _aviatorController.text = "";
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    "SUBMIT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "History",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot<Object?>>(
                              stream: aviatorSequence
                                  .orderBy('timestamp')
                                  .limitToLast(10)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot<Object?>>
                                  snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("Something went wrong");
                                }
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                final data = snapshot.requireData.docs
                                    .map((e) => Sequence.fromJson(
                                    e.data() as Map<String, dynamic>)
                                    .seq)
                                    .toList();
                                return Text(
                                  data.isEmpty ? "--" : data.join("\n"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14.0),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 80,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  aviatorSequence.get().then((snapshot) {
                                    for (DocumentSnapshot doc
                                    in snapshot.docs) {
                                      doc.reference.delete();
                                    }
                                  });
                                },
                                child: const Center(
                                  child: Text(
                                    "Clear",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
