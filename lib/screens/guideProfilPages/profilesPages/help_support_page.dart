import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/_widgets.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../widgets/web_view_container.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {

  late TextEditingController _textEditingControllerFeedBack;
  String? validationMessageFeedBack = '';
  bool isFormValid = false;
  bool _isDropdownOpened = false;
  List<String> _categories = ['Assistance avec une expérience', 'Assistance avec mon compte', 'Assistance avec l’application', 'Autre'];
  String _selectedCategory = 'Motif de la demande';

  @override
  void initState() {
    super.initState();
    _textEditingControllerFeedBack = TextEditingController();
    _textEditingControllerFeedBack.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerFeedBack.removeListener(_onTextChanged);
    _textEditingControllerFeedBack.dispose();
  }

  void _onTextChanged() {
    setState(() {
    });
  }

  void updateFormValidity() {
    setState(() {
      isFormValid =
          validationMessageFeedBack == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'FAQ & Assistance',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(31, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FAQ',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  blocHelp('FAQ Voyageurs', 'https://meetpe.fr/FAQVoyageurs'),
                  blocHelp('FAQ Guides', 'https://meetpe.fr/FAQGuides'),
                  blocHelp('FAQ Photos', 'https://meetpe.fr/FAQPhotos'),
                  blocHelp('Customer Expériences', 'https://meetpe.fr/Customer_Exp%C3%A9riences'),
                  const SizedBox(height: 15),
                  Text(
                    'Assistance',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Tu as une question concernant le fonctionnement de Meetpe ? Tu peux nous contacter via le formulaire suivant :',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 30),
                  blocAssistance('Nous contacter'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget blocHelp(String title, String url) {
    return InkWell(
      onTap: () {
        navigateTo(context, (_) => WebViewContainer(webUrl: url));
      },
      child: Column(
        children: [
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF797979)),
              ),
              Image.asset('images/chevron_right.png',
                  width: 27, height: 27, fit: BoxFit.fill),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            width: 390,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppResources.colorImputStroke,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget blocAssistance(String title) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: StatefulBuilder(
                  builder: (BuildContext context,
                      StateSetter setState) {
                    return Container(
                      width: double.infinity,
                      height: 459,
                      color: AppResources.colorWhite,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                            Text(
                              'Nous contacter',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 40,),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isDropdownOpened = !_isDropdownOpened;
                                });
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedCategory,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                                      ),
                                      Icon(Icons.keyboard_arrow_down, size: 24, color: Color(0xFF1C1B1F)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 1,
                                    color: AppResources.colorGray15,
                                  ),
                                  if (_isDropdownOpened)
                                    Container(
                                      height: 100, // Adjust height according to your content
                                      color: Colors.grey[200], // Example background color
                                      child: ListView.builder(
                                        itemCount: _categories.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text(_categories[index]),
                                            onTap: () {
                                              setState(() {
                                                _selectedCategory = _categories[index];
                                                _isDropdownOpened = false;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              controller: _textEditingControllerFeedBack,
                              keyboardType: TextInputType.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppResources.colorDark),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'On t’écoute ici, dis nous en plus sur ta demande',
                                hintStyle: Theme.of(context).textTheme.bodyMedium,
                                contentPadding: EdgeInsets.only(
                                    top: ResponsiveSize.calculateHeight(20, context),
                                    bottom:
                                    ResponsiveSize.calculateHeight(10, context)),
                                // Adjust padding
                                suffix: SizedBox(
                                    height:
                                    ResponsiveSize.calculateHeight(10, context)),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: AppResources.colorGray15),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: AppResources.colorGray15),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              //onFieldSubmitted: (value) => validate(),
                              validator: AppResources.validatorNotEmpty,
                              //onSaved: (value) => bloc.name = value,
                              onChanged: (value) {
                                setState(() {
                                  validationMessageFeedBack =
                                      AppResources.validatorNotEmpty(value);
                                  updateFormValidity();
                                });
                              },
                            ),
                            const SizedBox(height: 53,),
                            Container(
                              width: ResponsiveSize.calculateWidth(319, context),
                              height: ResponsiveSize.calculateHeight(44, context),
                              child: TextButton(
                                style: ButtonStyle(
                                  padding:
                                  MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: AppResources.colorDark),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'ENVOYER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppResources.colorDark),
                                ),
                                onPressed: () async {
                                  // Call the asynchronous operation and handle its completion
                                  AppService.api.sendFeedBack(_selectedCategory, _textEditingControllerFeedBack.text,).then((_) {
                                    // Optionally, you can perform additional actions after the operation completes
                                    showMessage(context, 'Ton message est bien envoyer.');
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }).catchError((error) {
                                    // Handle any errors that occur during the asynchronous operation
                                    print('Error: $error');
                                    showMessage(context, 'Ton message est bien envoyer.');
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    if(error.toString() != "type 'Null' is not a subtype of type 'bool' in type cast") {
                                      showMessage(context, error.toString());
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('images/support_agent.svg'),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF797979)),
                  ),
                ],
              ),
              Image.asset('images/chevron_right.png',
                  width: 27, height: 27, fit: BoxFit.fill),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            width: 390,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppResources.colorImputStroke,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
