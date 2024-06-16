import 'package:expense_tracker_app/bloc/create_categories/create_category_event.dart';
import 'package:expense_tracker_app/bloc/create_categories/create_category_state.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/bloc/create_categories/create_category_bloc.dart';
import 'package:expense_tracker_app/models/caregory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoriesIcons = [
    'entertainment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel'
  ];
  return showDialog(
      context: context,
      builder: (ctx) {
        bool isExpanded = false;
        String iconSelected = '';
        Color categoryColor = Colors.white;
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController categoryIconController = TextEditingController();
        TextEditingController categoryColorController = TextEditingController();
        bool isLoading = false;
        Category category = Category.empty;

        return BlocProvider.value(
          value: context.read<CreateCategoryBloc>(),
          child: StatefulBuilder(builder: (ctx, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(ctx, category);
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: AlertDialog(
                title: const Text(
                  'Create a Category',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: categoryNameController,
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
                        controller: categoryIconController,
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
                              itemCount: myCategoriesIcons.length,
                              itemBuilder: (context, int i) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      iconSelected = myCategoriesIcons[i];
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: iconSelected ==
                                                    myCategoriesIcons[i]
                                                ? 3
                                                : 1,
                                            color: iconSelected ==
                                                    myCategoriesIcons[i]
                                                ? Colors.green
                                                : Colors.grey),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/expenses/${myCategoriesIcons[i]}.png'))),
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
                        controller: categoryColorController,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                    content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorPicker(
                                        pickerColor: categoryColor,
                                        onColorChanged: (value) {
                                          setState(() {
                                            categoryColor = value;
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
                            fillColor: categoryColor,
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
                                      category.categoryId = const Uuid().v1();
                                      category.name =
                                          categoryNameController.text;
                                      category.icon = iconSelected;
                                      category.color = categoryColor.value;
                                    });

                                    context
                                        .read<CreateCategoryBloc>()
                                        .add(CreateCategory(category));
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
