/* http://qiita.com/sounisi5011/items/31972ed6cc8c1551291e の内容のコピペ
 * <div id="clock"></div> に格納される
 */
/**
 * Date.nowに対応していない場合、定義する
 * @link https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Date/now#Compatibility
 */
if (!Date.now) {
    Date.now = function now() {
        return new Date().getTime();
    };
}

/**
 * 時計表示要素を取得
 */
var clockE = document.getElementById('clock');

/**
 * 受信用のjsont関数を定義
 */
window.jsont = function (data) {
    var nowDate = Date.now();

    /**
     * 取得した標準時とコンピュータ側の時間との差を取得
     * @link http://qiita.com/hashrock/items/ce686c5b38d82be16390
     */
    var dateDiff = ((data.st * 1000) + ((nowDate - (data.it * 1000)) / 2)) - nowDate;

    /**
     * 時刻表示用関数を定義し、実行
     */
    function clock() {
        /**
         * 標準時とコンピュータ内蔵時計との差を考慮した
         * "ほぼ"正確な日付オブジェクトを取得
         */
        var date = new Date(Date.now() + dateDiff);

        /**
         * 時計を表示
         */
        setText(
            clockE,
            datePrintf('%y年%m月%d日 %h時%i分%s.%u秒', date)
        );

        /**
         * タイマーを設定し、50ミリ秒後に時計を更新
         */
        setTimeout(clock, 50);
    }
    clock();

    /**
     * jsont関数を削除
     */
    if (!(delete window.jsont)) {
        window.jsont = undefined;
    }
};

/**
 * script要素を作成し、NTPサーバのデータを取得する
 * NTPサーバは複数の中からランダムに選択し、負荷分散を試みる
 * @link http://bashalog.c-brains.jp/14/03/05-100000.php
 */
var serverList = [
    'https://ntp-a1.nict.go.jp/cgi-bin/jsont',
    'https://ntp-b1.nict.go.jp/cgi-bin/jsont',
];
var scriptE = document.createElement('script');
// NTPサーバのURLに発信時刻を追加
var serverUrl = serverList[Math.floor(Math.random() * serverList.length)];
scriptE.src = serverUrl + '?' + (Date.now() / 1000);
document.body.appendChild(scriptE);





/**
 * 数値のゼロ埋めをする
 *
 * @param {number} number 対象の数値
 * @param {number} digit 必要な桁数
 * @return {string} ゼロ埋めされた文字列
 */
var zeroFill = function (number, digit) {
    return ('00' + number).slice(digit * -1);
};

/**
 * 要素にテキストを設定する。textContentプロパティのクロスブラウザ関数
 * @param {Node} targetNode 設定対象の要素
 * @param {string} text 設定するテキスト
 */
var setText =
    ('textContent' in document.documentElement) ?
    function (targetNode, text) {
        /**
         * 対象要素のtextContentプロパティに新しいテキストを代入
         */
        targetNode.textContent = text;
    } :
    function (targetNode, text) {
        /**
         * 対象要素内の全子要素を削除
         */
        var childNode;
        while ((childNode = targetNode.firstChild)) {
            targetNode.removeChild(childNode);
        }
        /**
         * テキストノードを挿入
         */
        targetNode.appendChild(
            document.createTextNode(text)
        );
    }
;

/**
 * 指定の文字列をフォーマットし、日付文字列に変換する
 * フォーマットパラメータは以下の8つがある
 * + %y : 年
 * + %m : 月
 * + %d : 日
 * + %h : 時
 * + %i : 分
 * + %s : 秒
 * + %u : ミリ秒
 * + %% : ただの"%"
 *
 * @param {?string=} format フォーマット対象の文字列。
 * 省略された場合、"%y/%m/%d %h:%i:%s.%u"になる
 * @param {?Date=} date 日付を指定する場合、ここに日付オブジェクトを指定する
 * @return {string} フォーマットされた文字列
 */
var datePrintf = function (format, date) {
    if (!format) {
        format = '%y/%m/%d %h:%i:%s.%u';
    }
    if (!(date instanceof Date)) {
        date = new Date();
    }
    var
        year = date.getFullYear(),
        month = zeroFill(date.getMonth() + 1, 2),
        date_n = zeroFill(date.getDate(), 2),
        hour = zeroFill(date.getHours(), 2),
        minute = zeroFill(date.getMinutes(), 2),
        second = zeroFill(date.getSeconds(), 2),
        milli_second = zeroFill(date.getMilliseconds(), 3)
    ;
    return format.replace(/(%*)%([ymdhisu])/g, function (a, escape_str, type) {
        if (escape_str.length % 2 === 0) {
            switch (type) {
                case 'y':
                    type = year;
                    break;
                case 'm':
                    type = month;
                    break;
                case 'd':
                    type = date_n;
                    break;
                case 'h':
                    type = hour;
                    break;
                case 'i':
                    type = minute;
                    break;
                case 's':
                    type = second;
                    break;
                case 'u':
                    type = milli_second;
                    break;
            }
        }
        return escape_str.replace(/%%/g, '%') + type;
    });
};