const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

exports.issueCustomToken = onRequest(async (req, res) => {
  try {
    const kakaoAccessToken = req.body.accessToken;
    if (!kakaoAccessToken) {
      return res.status(400).send("No access token provided.");
    }

    // 🔹 Kakao API로 사용자 정보 요청
    const kakaoResponse = await axios.get("https://kapi.kakao.com/v2/user/me", {
      headers: {
        Authorization: `Bearer ${kakaoAccessToken}`,
      },
    });

    const kakaoUser = kakaoResponse.data;
    const uid = `kakao:${kakaoUser.id}`; // 고유 사용자 ID

    // 🔹 Firebase Custom Token 발급
    const customToken = await admin.auth().createCustomToken(uid);
    return res.json({ token: customToken });

  } catch (error) {
    logger.error("Error issuing custom token:", error);
    return res.status(500).send("Internal Server Error");
  }
});