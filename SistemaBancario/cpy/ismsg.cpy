*>********************************************************************<*
*>***** Copyright (c) 2005 - 2019 Veryant. Users of isCOBOL      *****<*
*>***** may freely modify and redistribute this program.         *****<*
*>********************************************************************<*

       >>SOURCE FORMAT FREE


is-extended-file-status.
    call "c$rerrname" using is-err-file
    call "c$rerr" using extend-stat, text-message
       move primary-error to is-msg-id
       perform is-show-msg
    .
is-show-msg.
    move space to is-msg-1 is-msg-2 is-msg-3
    evaluate is-msg-id
    when 10
       move "no more data."  to is-msg-1
       move mb-default-icon to is-icon-type
       move mb-ok to is-button-type
    when 22
       move "key duplication." to is-msg-1
       move mb-error-icon to is-icon-type
       move mb-ok to is-button-type
    when 23
       move "record not found." to is-msg-1
       move mb-warning-icon to is-icon-type
       move mb-ok to is-button-type
    when 101
       move "quit?" to is-msg-1
       move 4 to is-icon-type
       move mb-yes-no to is-button-type
    when 201
       move "add record?" to is-msg-1
       move 4 to is-icon-type
       move mb-yes-no to is-button-type
    when 202
       move "update record?" to is-msg-1
       move 4 to is-icon-type
       move mb-yes-no to is-button-type
    when 203
       move "delete record?" to is-msg-1
       move 4 to is-icon-type
       move mb-yes-no to is-button-type
    when 204
       move "key duplication." to is-msg-1
       move mb-warning-icon to is-icon-type
       move mb-ok to is-button-type
    when 301
       move "add successful." to is-msg-1
       move mb-default-icon to is-icon-type
       move mb-ok to is-button-type
    when 302
       move "update successful." to is-msg-1
       move mb-default-icon to is-icon-type
       move mb-ok to is-button-type
    when 303
       move "delete successful." to is-msg-1
       move mb-default-icon to is-icon-type
       move mb-ok to is-button-type
    when 401
       move "shell not found." to is-msg-1
       move mb-error-icon to is-icon-type
       move mb-ok to is-button-type
 *> user-defined message
    when 901
       move mb-warning-icon to is-icon-type
       move mb-ok to is-button-type
    when other
       move text-message to is-msg-1
       string "file:" is-err-file delimited by space
          into is-msg-2
       string "file status ", primary-error "," secondary-error
          delimited by size into is-msg-3
    end-evaluate
    perform is-message-box
    .

is-message-box.
    move 1 to is-text-ptr
    if is-msg-1 not = space
       move 0 to is-size
       inspect is-msg-1 tallying is-size for trailing space
       string is-msg-1( 1 : is-length - is-size )
          delimited by size
          into is-msg-text, pointer is-text-ptr
    end-if

    if is-msg-2 not = space
       move 0 to is-size
       inspect is-msg-2 tallying is-size for trailing space
       if is-text-ptr > 1
          string x"0a" delimited by size
              into is-msg-text, pointer is-text-ptr
       end-if
       string is-msg-2( 1 : is-length - is-size )
           delimited by size
           into is-msg-text, pointer is-text-ptr
    end-if

    if is-msg-3 not = space
       move 0 to is-size
       inspect is-msg-3 tallying is-size for trailing space
       if is-text-ptr > 1
          string x"0a" delimited by size
              into is-msg-text, pointer is-text-ptr
       end-if
       string is-msg-3( 1 : is-length - is-size )
           delimited by size
           into is-msg-text, pointer is-text-ptr
    end-if

    if is-text-ptr = 1
      move 0 to is-size
      inspect is-msg-text tallying is-size for trailing space
      compute is-text-ptr = is-full-len - is-size + 1
    end-if
    move low-values to is-msg-text( is-text-ptr : 1 )

    display message box
       is-msg-text
       type is is-button-type
       icon is is-icon-type
       default is is-default-button
       returning is-return-value
    .

       >>SOURCE FORMAT PREVIOUS