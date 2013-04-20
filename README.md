# RVocalware

Text-to-speech tool using the [Vocalware HTTP REST API](https://www.vocalware.com/support/rest-api). Requires you to [sign up for a Vocalware account](https://www.vocalware.com/auth/signup) then [create an API](https://www.vocalware.com/myapis/) so that you have an Account ID, an API ID, and a Secret Phrase.

# Installation

`bundle install` to install the necessary gems. Then run `rvocalware.rb` with the following parameters:

    Options:
           --lid, -l <i>:   Language ID (default: 1)
           --vid, -v <i>:   Voice ID (default: 3)
           --txt, -t <s>:   Text to be used for audio creation (encoded)
           --ext, -e <s>:   SWF or MP3; default MP3 (default: mp3)
       --fx-type, -f <s>:   Sound effect type; default empty
      --fx-level, -x <s>:   Sound effect level; default empty
           --acc, -a <s>:   Account ID
           --api, -p <s>:   API ID
       --session, -s <s>:   Used to verify the session
        --secret, -c <s>:   Secret phrase
              --help, -h:   Show this message

For example:

    ruby rvocalware.rb --txt "Hello from Ruby" --secret "myAwesomeSecretKey" --acc 12345678 --api 98765432
