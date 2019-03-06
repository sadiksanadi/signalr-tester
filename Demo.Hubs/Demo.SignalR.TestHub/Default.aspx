﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Microsoft.AspNet.SignalR.TestHub.Default" %>
<!DOCTYPE html>
<html>
<head>
    <title>SignalR Simple Chat</title>
    <style type="text/css">
        .container {
            background-color: #99CCFF;
            border: thick solid #808080;
            padding: 20px;
            margin: 20px;
        }
        .discussion{
            float:left;
            top:0;
            margin-top:35px;
        }
        .loggedOnUsers{
            float:right;
            top:0;
            position:relative;
            margin-top:34px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div>
            <input type="text" id="message" />
            <input type="button" id="sendmessage" value="Send" />
            <input type="hidden" id="displayname" />
        </div>

        <div class="discussion">
            <label><strong>Messages</strong></label>
            <ul  id="discussion"></ul>
        </div>
        <div class="loggedOnUsers" >
            <label><strong>Logged In Users</strong></label>
            <ul id="loggedOnUsers"></ul>
        </div>
    </div>
    <!--Script references. -->
    <!--Reference the jQuery library. -->
    <script src="Scripts/jquery-1.8.2.min.js"></script>
    <!--Reference the SignalR library. -->
    <script src="/Scripts/jquery.signalR-2.3.0.min.js"></script>
    <!--Reference the autogenerated SignalR hub script. -->
    <script src="/signalr/hubs"></script>
    <!--Add script to update the page and send messages.-->
    <script type="text/javascript">
        $(function () {
            // Declare a proxy to reference the hub.
            var chat = $.connection.chatHub;
            // Create a function that the hub can call to broadcast messages.
            chat.client.broadcastMessage = function (name, message) {
                // Html encode display name and message.
                var encodedName = $('<div />').text(name).html();
                var encodedMsg = $('<div />').text(message).html();
                // Add the message to the page.
                $('#discussion').append('<li><strong>' + encodedName
                    + '</strong>:&nbsp;&nbsp;' + encodedMsg + '</li>');
            };
            chat.client.onlogOn = function (name) {
                // Html encode display name.
                var encodedName = $('<div />').text(name).html();
                // Add the message to the page.
                $('#loggedOnUsers').append('<li><strong>' + encodedName + '</li>');
            };
            // Get the user name and store it to prepend to messages.
            $('#displayname').val(prompt('Enter your name:', ''));
            // Set initial focus to message input box.
            $('#message').focus();
            // Start the connection.
            $.connection.hub.start().done(function () {
                $('#sendmessage').click(function () {
                    // Call the Send method on the hub.
                    chat.server.send($('#displayname').val(), $('#message').val());
                    // Clear text box and reset focus for next comment.
                    $('#message').val('').focus();
                });
            });
        });
    </script>
</body>
</html>
