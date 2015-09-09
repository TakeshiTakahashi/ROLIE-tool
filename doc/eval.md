# Rolieサーバーのフィージビリティ評価報告書

* (株)レピダム 前田薫
* 2015/09/09

## はじめに

Mile-Rolie仕様ドラフト[1]にしたがって、Rolieサーバーをプロトタイプし、
その評価を行った。

## 評価項目

* 作成したプロトタイプが、Rolie仕様ドラフト[1]の以下の仕様を満たしていることを評価する
  * 5.4: Content Model
    * IODEF schema
  * 5.5: HTTP methods
    * GET
    * PUT
    * POST
    * DELETE
    * HEAD
  * 5.6: Service Discovery
    * Atom Service Document
  * 5.8: Entry ID
    * IncidentIDの生成
    * IncidentIDからのURLの生成
  * 5.9: Entry Content
  * 5.12: Date Mapping
  * 5.13: Search

## 評価手順・評価基準

README.mdにしたがい、以下の手順を実行する

* 1 準備
  * サーバーのセットアップおよび起動
  * Entryを1件追加する
    * /csirt/public/incidentsに対しexample/codered-entry.xmlを追加
      * `curl -D - -X POST http://localhost:3000/csirt/public/incidents --data-binary @codered-entry.xml`
* 2 Service Directoryの取得
  * 2.1 Service Directoryへのリンク
    * HTTPリクエスト: `GET /`
    *  評価基準
      * 2.1.1 HTML head内にlink要素が存在すること: rel="introspection" type="application/atomsvc+xml"
  * 2.2 Service Documentの取得
    * 上記で得られたURLに対してHTTP GETリクエストを実行
    * 評価基準
      * 2.2.1 少なくともひとつのworkspaceがあること
      * 2.2.2 そのworkspaceが少なくともひとつのaccept可能なcollectionを持つこと
* 3 Collection Feedの取得
  * 3.1 上記Service Documentで得られたcollectionのURLに対してHTTP GETリクエストを実行
    * `curl -D - http://localhost:3000/csirt/public/incidents`
  * 評価基準
    * 3.1.1 以下のlink要素が存在すること
      * rel="self"で自己のURL
      * rel="search"でOpenSearch検索フォーマット取得URL
    * 準備で追加した1件のEntryが得られること
      * entry要素内にエントリの以下の情報が含まれること
        * 3.1.2 id: IDはエントリのURLであること
        * 3.1.3 updated: 準備で追加した日時であること
        * 3.1.4 entry内のlink要素があること
* 4 Entryの追加
  * 4.1 collectionのURLに対してHTTP POSTリクエストを実行
    * `curl -D - -X POST http://localhost:3000/csirt/public/incidents --data-binary @minimum-entry.xml`
  * 評価基準
    * HTTPレスポンス
      * 4.1.1 レスポンスコードが201であること
      * 4.1.2 LocationヘッダにEntryのURLがあること
      * bodyにエントリ自体が入っていること
        * 4.1.3 id要素が、本サービスのURLで置きかえられていること
        * 4.1.4 published要素にコンテンツIODEF内のreporttimeの値が入っていること
        * 4.1.5 updated要素にPOST実行時刻が入っていること
        * 4.1.6 content要素にIODEFが入っていること
        * 4.1.7 IODEF内のIncidentID要素が、本サービスのIDで置きかえられていること
    * 4.1.8 Collectionを取得すると、いまPOSTしたエントリが追加されていること
* 5 Entryの取得
  * 5.1 上記で得られたエントリのURLに対してHTTP GETリクエストを実行
    * `curl -D - -X GET http://localhost:3000/csirt/public/incidents/2`
    * 評価基準
      * 5.1.1 追加時のレスポンスbodyと同じ内容が返ってくること
  * 5.2 同URLに対しHTTP HEADリクエストを実行
    * `curl -D - -X HEAD http://localhost:3000/csirt/public/incidents/2`
    * 評価基準
      * 5.2.1 GET時と同様のHTTPレスポンスヘッダが得られること
* 6 Entryの更新
  * 6.1 上記のEntryオブジェクトのURLに対し、HTTP PUTリクエストを実行
    * `curl -D - -X PUT http://localhost:3000/csirt/public/incidents/2 --data-binary @codered-entry.xml`
  * 評価基準
    * HTTPレスポンス
      * 6.1.1 レスポンスコードが200であること
      * 6.1.2 bodyに更新後のエントリが入っていること
    * 6.1.3 Collectionを取得すると、いまPUTしたEntryの内容が更新されていること
    * 6.1.4 Entryを取得すると、内容が更新されていること
* 7 Entryの削除
  * 7.1 上記のEntryオブジェクトのURLに対し、HTTP DELETEリクエストを実行
    * `curl -D - -X DELETE http://localhost:3000/csirt/public/incidents/2`
  * 評価基準
    * HTTPレスポンス
      * 7.1.1 レスポンスコードが200または204であること
      * 7.1.2 bodyが空であること
    * 7.1.3 Collectionを取得すると、いまDELETEしたEntryが存在しないこと
    * 7.1.4 Entryを取得すると、404が返ること
* 8 検索
  * 8.1 OpenSearch検索フォーマットの取得
    * 上記Collectionから得られたOpenSearch検索フォーマット取得URLに対し、HTTP GETリクエストを実行
      * `curl http://localhost:3000/searchspec/public/incidents`
    * 評価基準
      * 8.1.1 OpenSearch 1.1準拠のURLテンプレートが得られること
  * 8.2 検索の実行
    * 準備
      * 上記で更新したオブジェクトを元に戻す
        * `curl -D - -X POST http://localhost:3000/csirt/public/incidents --data-binary @minimum-entry.xml`
    * 検索の実行: 検索文字列としてexampleを指定して検索を行う
      * `curl 'http://localhost:3000/csirt/public/incidents?q=example'`
    * 評価基準
      * 8.2.1 Atom Feedが得られること
      * 8.2.2 codered-entryが結果に含まれること
      * 8.2.3 minimum-entryが結果に含まれないこと

* 評価基準と評価項目の対応
  * 5.4: Content Model
    * IODEF schema: 4.1.6
    * Collection: 3.1.1～3.1.4
    * Entry: 5.1.1
  * 5.5: HTTP methods
    * GET: Collection 3.1.1, Entry: 5.1.1
    * PUT: 6.1.1～6.1.4
    * POST: 4.1.1～4.1.8
    * DELETE: 7.1.1～7.1.4
    * HEAD: 5.2.1
  * 5.6: Service Discovery
    * Atom Service Document: 2.1.1, 2.2.1～2.2.2
  * 5.8: Entry ID
    * IncidentIDの生成: 4.1.7
    * IncidentIDからのURLの生成: 4.1.3
  * 5.9: Entry Content: 4.1.1～4.1.8
  * 5.12: Date Mapping: 4.1.4, 4.1.5
  * 5.13: Search: 8.1.1, 8.2.1～8.2.3

## 評価結果

* 評価の実施日時: 2015/09/09 21:50-22:05
* 評価の実施者: 前田薫
* 評価結果
  * 上記評価手順どおりに評価を実施し、すべての評価基準を満たした
  * 特記事項
    * 7.1.1: レスポンスコードは200であった
    * 7.1.4: レスポンスコードは404であったが、bodyにデバッグ用の情報が出力されていた。仕様上は問題ない
* 以上から、Rolieサーバープロトタイプは、評価項目に列挙した仕様を満たすことを確認した
  * Mile-Rolie仕様ドラフト[1]の基本仕様にしたがって、Rolieサーバーを構成することが可能であることを示した

## Mile-Rolie仕様ドラフトの質問に対する提案

* Mile-Rolie仕様ドラフト[1]セクション8には、ドラフト著者からの仕様に関する議論点が列挙されている。これらに対する提案を以下に述べる。

1.  Need to make a decision on whether new IANA link registrations are required, or whether fully qualified (private) link types are sufficient.
  * IANAリポジトリを作成するとよいだろう。このとき、リポジトリへの追加や更新に関するルールを定める必要がある。expert reviewが適当であろう

2.  Should we require Atom categories that correspond to IODEF Expectation class and/or IODEF Impact class?
  * section 5.7のとおりでよいだろう。
  * RFC5070のIODEF `<xs:attribute name="purpose" use="required">` でよい。

3.  Should we include specific requirements for Archive and Paging? Perhaps just reference RFC 5005?
  * Server MAY provide paged feeds according to RFC5005. とすればよい

4.  We need more requirements input on use cases involving RID schema in the Atom member entry content model for link rel=report.
  * 現状のままでよいと思われる。十分なユースケースが得られた時点で更新を検討すればよい。

5.  An Atom service document will have categories, but this is still coarse-grained, and not visible at the transport protocol level. Should we include a MIME media type parameter to support negotiation and better document the content model schema contained in a collection, i.e.:
  * `Accept: application/atom+xml;type=entry;content=iodef`
  * `Accept: application/atom+xml;type=entry;content=rid`
  * `Accept: application/atom+xml;type=entry;content=iodef+openioc`
  * Mime-typeによる制御は、同一のURLに対応するリソースの異なる表現である場合が望ましい。これらの3者の間ではsemanticsが異なるためMime-typeではなくpathあるいはextensionで制御すべきと考える。

6.  If so, I think these parameters may require media type registration as per RFC4288?
  * 5をやらないため、N/A

## 参考文献

* [1] Resource-Oriented Lightweight Indicator Exchange http://tools.ietf.org/html/draft-ietf-mile-rolie-00

以上
