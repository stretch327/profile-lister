package jwt

import (
	"encoding/base64"
	"jwtsign/signature"
	"strings"
)

/*
 *	JWT Data Struct
 *	xxxxxx.yyyyyyyy.zzzzzzzzz
 *	Header.Payload.Signature
 *	@see:
 *		https://developer.apple.com/documentation/applemusicapi/getting_keys_and_creating_tokens
 *		https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_token-based_connection_to_apns
 */

func Token(header string, payload string, keyfile string) (string, error) {

	// Step 1: Build JWT Header
	header64 := strings.TrimRight(base64.URLEncoding.EncodeToString([]byte(header)), "=")

	// Step 2: Build JWT Payload
	payload64 := strings.TrimRight(base64.URLEncoding.EncodeToString([]byte(payload)), "=")

	// Step 3: Signature Header & Payload
	sign64, err := signature.Sign(header64, payload64, keyfile)
	if nil != err {
		return "Signing error", err
	}

	token := header64 + "." + payload64 + "." + sign64

	return token, nil

}
