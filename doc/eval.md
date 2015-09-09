# Rolieサーバーのフィージビリティ評価報告書

* (株)レピダム 前田薫
* 2015/09/09

## はじめに

Mile-Rolie仕様ドラフト[1]にしたがって、Rolieサーバーをプロトタイプし、
その評価を行った。

## 評価項目

* Rolie serverの以下の機能が働いていることをテストした
  * 5.5: HTTP methods
    * GET
    * PUT
    * POST
    * DELETE
    * HEAD
  * 5.6: Service Discovery
  * 5.8: Entry ID
    * IncidentIDの生成
  * 5.12: Date Mapping
  * 5.13: Search

## 評価手順・評価基準

README.mdにしたがい、以下の手順を実行する

1. 準備
  1. サーバーのセットアップおよび起動
  1. Entryを1件追加する
    1. /csirt/public/incidentsに対しexample/codered-entry.xmlを追加
      1. `curl -D - -X POST http://localhost:3000/csirt/public/incidents --data-binary @codered-entry.xml`
1. Service Directoryの取得
  1.  Service Directoryへのリンク
    1. HTTPリクエスト: `GET /`
    1.  評価基準
      1. link要素が存在すること: rel="introspection" type="application/atomsvc+xml"
  1. Service Documentの取得
    1. 上記で得られたURLに対してHTTP GETリクエストを実行
    1. 評価基準
      1. 少なくともひとつのworkspaceがあること
      1. そのworkspaceが少なくともひとつのaccept可能なcollectionを持つこと
1. Collection Feedの取得
  1. 上記Service Documentで得られたcollectionのURLに対してHTTP GETリクエストを実行
    1. `curl -D - http://localhost:3000/csirt/public/incidents`
  1. 評価基準
    1. 以下のlink要素が存在すること
      1. rel="self"で自己のURL
      1. rel="search"でOpenSearch検索フォーマット取得URL
    1. 準備で追加した1件のEntryが得られること
      1. entry要素内にエントリの以下の情報が含まれること
        1. id: IDはエントリのURLであること
        1. updated: 準備で追加した日時であること
        1. entry内のlink要素があること
1. Entryの追加
  1. collectionのURLに対してHTTP POSTリクエストを実行
    1. `curl -D - -X POST http://localhost:3000/csirt/public/incidents --data-binary @minimum-entry`
  1. 評価基準
    1. HTTPレスポンス
      1. レスポンスコードが201であること
      1. LocationヘッダにEntryのURLがあること
      1. bodyにエントリ自体が入っていること
        1. id要素が、本サービスのURLで置きかえられていること
        1. published要素にコンテンツIODEF内のreporttimeの値が入っていること
        1. updated要素にPOST実行時刻が入っていること
        1. IODEF内のIncidentID要素が、本サービスのURLで置きかえられていること
    1. Collectionを取得すると、いまPOSTしたエントリが追加されていること
      1. Collectionのupdated時刻が更新されていること
1. Entryの取得
  1. 上記で得られたエントリのURLに対してHTTP GETリクエストを実行
    1. `curl -D - -X GET http://localhost:3000/csirt/public/incidents/2`
  1. 評価基準
    1. 追加時のレスポンスbodyと同じ内容が返ってくること
1. Entryの更新
  1. 上記のEntryオブジェクトのURLに対し、HTTP PUTリクエストを実行
    1. `curl -D - -X PUT http://localhost:3000/csirt/public/incidents/2 --data-binary @codered-entry`
  1. 評価基準
    1. HTTPレスポンス
      1. レスポンスコードが200であること
      1. bodyに更新後のエントリが入っていること
    1. Collectionを取得すると、いまPUTしたEntryの内容が更新されていること
    1. Entryを取得すると、内容が更新されていること
1. Entryの削除
  1. 上記のEntryオブジェクトのURLに対し、HTTP DELETEリクエストを実行
    1. `curl -D - -X DELETE http://localhost:3000/csirt/public/incidents/2`
  1. 評価基準
    1. HTTPレスポンス
      1. レスポンスコードが200であること
      1. bodyが空であること
    1. Collectionを取得すると、いまDELETEしたEntryが存在しないこと
    1. Entryを取得すると、404が返ること

## 参考文献

* [1] Resource-Oriented Lightweight Indicator Exchange http://tools.ietf.org/html/draft-ietf-mile-rolie-00
