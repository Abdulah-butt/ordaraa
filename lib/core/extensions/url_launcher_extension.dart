import 'package:url_launcher/url_launcher.dart';

extension LaunchUrl on String {
  Future<void> launchUrlInBrowser() async {
    if (await canLaunchUrl(Uri.parse(this))) {
      final uri = Uri.parse(this);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch link : $this');
    }
  }

  void launchPhoneNumber() {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: this,
    );
    launchUrl(callUri);
  }

  Future<void> launchSMS() async {
    // Check for SMS capability
    if (await canLaunchUrl(Uri(scheme: 'sms'))) {
      final uri = Uri(scheme: 'sms', path: this);
      await launchUrl(uri);
    } else {
      // Handle unsupported SMS
      throw Exception('Could not launch SMS');
    }
  }

  Future<void> launchWhatsApp() async {
    // Check for WhatsApp capability
    // Note: WhatsApp URL scheme might vary based on platform and installation
    final whatsappUrlAndroid = Uri.parse("whatsapp://send?phone=$this");
    final whatsappUrlIOS = Uri.parse("https://wa.me/$this");
    if (await canLaunchUrl(whatsappUrlAndroid)) {
      await launchUrl(whatsappUrlAndroid);
    } else if (await canLaunchUrl(whatsappUrlIOS)) {
      await launchUrl(whatsappUrlIOS);
    } else {
      // Handle unsupported WhatsApp
      throw Exception('Could not launch WhatsApp');
    }
  }

  String toValidUrl() {
    // Trim and normalize the input string
    String trimmed = trim().toLowerCase();

    if (trimmed.isEmpty) {
      return this;
    }
    // If the string already starts with http or https, we'll assume it's a valid URL
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    // If the string starts with www., add the http prefix
    if (trimmed.startsWith('www.')) {
      return 'https://$trimmed';
    }

    // If the string contains a dot (.) but doesn't start with http, assume it's a domain
    if (trimmed.contains('.') &&
        !trimmed.startsWith('http://') &&
        !trimmed.startsWith('https://')) {
      return 'https://$trimmed';
    }

    // For plain strings without any dots, treat them as base domain names
    return 'https://www.$trimmed.com';
  }
}
