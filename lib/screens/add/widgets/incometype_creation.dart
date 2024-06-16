import 'package:expense_tracker_app/bloc/create_incometype/create_incometype_bloc.dart';
import 'package:expense_tracker_app/models/incometype.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

Future getIncomeTypeCreation(BuildContext context) {
  List<String> incomeTypeIcons = [
    'awards',
    'investment',
    'others',
    'part_time',
    'salary1',
  ];
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        bool isExpanded = false;
        String iconSelected = '';
        Color incometypeColor = Colors.white;
        TextEditingController incometypeNameController =
            TextEditingController();
        TextEditingController incometypeIconController =
            TextEditingController();
        TextEditingController incometypeColorController =
            TextEditingController();
        bool isLoading = false;
        IncomeType incometype = IncomeType.empty;

        return BlocProvider.value(
          value: context.read<CreateIncometypeBloc>(),
          child: StatefulBuilder(builder: (ctx, setState) {
            return BlocListener<CreateIncometypeBloc, CreateIncometypeState>(
              listener: (context, state) {
                if (state is CreateIncometypeSuccess) {
                  Navigator.pop(ctx, incometype);
                } else if (state is CreateIncometypeLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: AlertDialog(
                title: const Text(
                  'Create a Income Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: incometypeNameController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Name",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: incometypeIconController,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              size: 30,
                              color: Colors.grey,
                            ),
                            isDense: true,
                            hintText: "Icon",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: isExpanded
                                    ? const BorderRadius.vertical(
                                        top: Radius.circular(12))
                                    : BorderRadius.circular(30),
                                borderSide: BorderSide.none)),
                      ),
                      Visibility(
                        visible: isExpanded,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: incomeTypeIcons.length,
                              itemBuilder: (context, int i) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      iconSelected = incomeTypeIcons[i];
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: iconSelected ==
                                                    incomeTypeIcons[i]
                                                ? 3
                                                : 1,
                                            color: iconSelected ==
                                                    incomeTypeIcons[i]
                                                ? Colors.green
                                                : Colors.grey),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                            scale: 4,
                                            image: AssetImage(
                                              'assets/income/${incomeTypeIcons[i]}.png',
                                            ))),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: incometypeColorController,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                    content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorPicker(
                                        pickerColor: incometypeColor,
                                        onColorChanged: (value) {
                                          setState(() {
                                            incometypeColor = value;
                                          });
                                        }),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 35, 34, 34),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12))),
                                          onPressed: () {
                                            Navigator.pop(ctx2);
                                          },
                                          child: const Text(
                                            'Ok',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  ],
                                ));
                              });
                        },
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "Color",
                            filled: true,
                            fillColor: incometypeColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: kToolbarHeight,
                          child: isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 35, 34, 34),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  onPressed: () {
                                    setState(() {
                                      incometype.incomeTypeId =
                                          const Uuid().v1();
                                      incometype.name =
                                          incometypeNameController.text;
                                      incometype.icon = iconSelected;
                                      incometype.color = incometypeColor.value;
                                    });

                                    context
                                        .read<CreateIncometypeBloc>()
                                        .add(CreateIncometype(incometype));
                                  },
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )))
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      });
}
