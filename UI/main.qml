import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Window 2.15

// ===================================================================
// 1. メインの設定ウィンドウ（起動時に中央に出る小さなUI）
// ===================================================================
ApplicationWindow {
    id: settingsWindow
    visible: true
    title: "Welcome to vb2026-utility-tools"
    
    // ウィンドウサイズを固定
    width: 600
    height: 400
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    Material.theme: Material.Dark
    Material.accent: Material.Teal

    onClosing: {
        Qt.quit()
    }

    // 背景
    Rectangle {
        anchors.fill: parent
        color: "#1e1e24"

        Column {
            anchors.centerIn: parent
            spacing: 15
            width: parent.width - 40

            Text {
                text: "アプリケーション設定"
                color: "white"
                font.pixelSize: 36
                font.bold: true
                anchors.horizontalCenter: parent
            }

            // 画面選択用のドロップダウン（コンボボックス）
            Row {
                spacing: 10
                anchors.horizontalCenter: parent
                Text { text: "表示画面:"; color: "white"; anchors.verticalCenter: parent.verticalCenter }
                ComboBox {
                    id: screenCombo
                    width: 180
                    // とりあえずモック用のダミーデータ（後でC++から実データを入れます）
                    model: ["画面 ID: 1 (メイン)", "画面 ID: 2 (サブ)"] 
                }
            }

            // カメラ選択用のドロップダウン
            Row {
                spacing: 10
                anchors.horizontalCenter: parent
                Text { text: "カメラ:  "; color: "white"; anchors.verticalCenter: parent.verticalCenter }
                ComboBox {
                    id: cameraCombo
                    width: 180
                    model: ["Webカメラ (Logicool)", "内蔵カメラ", "未接続"]
                }
            }

            // 次へ進むボタン
            Button {
                text: "次へ進む"
                highlighted: true
                anchors.horizontalCenter: parent
                width: 120
                onClicked: {
                    console.log("選択された画面索引:", screenCombo.currentIndex)
                    console.log("選択されたカメラ索引:", cameraCombo.currentIndex)
                    
                    // 【画面遷移の処理】
                    // 設定画面とすべての画面ID表示を閉じる
                    settingsWindow.close()
                    // 本来ならここでメイン画面（カメラ映像）を開く処理を走らせます
                }
            }
        }
    }

    // ===================================================================
    // 2. 画面IDを各モニターの右下に強制表示する機能（オーバーレイ）
    // ===================================================================
    // Instantiator を使うと、PCに繋がっているモニター（Screen）の数だけ
    // 自動的に中の Window をポコポコ量産してくれます！
    Instantiator {
        model: Qt.application.screens // 接続されている全画面のリスト

        delegate: Window {
            // modelData に各モニターの情報（解像度や位置）が入っています
            required property var modelData
            required property int index

            visible: true
            
            // 枠無しの透明なウィンドウにする（文字だけを浮かせるため）
            flags: Qt.FramelessWindowHint | Qt.WindowTransparentForInput | Qt.WindowStaysOnTopHint
            color: "transparent"

            // 各モニターの「右下」に配置されるように座標を計算
            // （モニターの開始X座標 + モニター横幅 - 自分の横幅）
            width: 240
            height: 120
            x: modelData.virtualX + modelData.width - width - 20
            y: modelData.virtualY + modelData.height - height - 20

            // 画面IDを表示する小さな半透明の座布団
            Rectangle {
                anchors.fill: parent
                color: "#aa000000" // 70%透明な黒
                radius: 8
                border.color: "#00f0ff" // ネオンブルーの枠線
                border.width: 1

                Text {
                    // インデックスは0から始まるので、+1 して「画面 1」「画面 2」とする
                    text: "画面 ID: " + (index + 1)
                    color: "#00f0ff"
                    font.bold: true
                    font.pixelSize: 32
                    anchors.centerIn: parent
                }
            }
        }
    }
}