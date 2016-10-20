import QtQuick 2.4
import LibQTelegram 1.0
import "../component/message"

Item
{
    property var context
    property real maxWidth

    id: messagemodelitem
    height: content.height

    width: {
        if(model.isServiceMessage)
            return maxWidth;

        var w = Math.max(lblhiddenfrom.contentWidth, lblhiddenmessage.contentWidth, mediamessageitem.contentWidth)
        return Math.min(w, maxWidth);
    }

    anchors {
        right: !model.item.isOut ? undefined : parent.right
        left: model.item.isOut ? undefined : parent.left
        rightMargin: Theme.paddingMedium
        leftMargin: Theme.paddingMedium
    }

    MessageBubble
    {
        anchors { fill: parent; margins: -Theme.paddingSmall }
        tgMessage: model.item

        visible: {
            if(mediamessageitem.isSticker || mediamessageitem.isAnimated)
                return false;

            return !model.isServiceMessage;
        }
    }

    Column
    {
        id: content
        width: parent.width

        Text { id: lblhiddenfrom; text: model.messageFrom; visible: false }
        Text { id: lblhiddenmessage; text: model.messageText; visible: false }

        Text
        {
            id: lblfrom
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            visible: messagesmodel.isChat && !model.item.isOut
            text: lblhiddenfrom.text
        }

        MediaMessageItem
        {
            id: mediamessageitem
            message: model.item
            size: parent.width

            locationDelegate: function(latitude, longitude){
                return context.locationThumbnail(latitude, longitude, maxWidth, maxWidth, 14);
            }
        }

        MessageText
        {
            id: lblmessage
            width: parent.width
            emojiPath: context.qtgram.emojiPath
            rawText: lblhiddenmessage.text
            wrapMode: Text.Wrap
            font { italic: model.isServiceMessage }

            color: {
                if(model.isServiceMessage)
                    return "gray";

                return "black";
            }

            horizontalAlignment: {
                if(model.isServiceMessage)
                    return Text.AlignHCenter;

                return Text.AlignLeft;
            }
        }
    }
}