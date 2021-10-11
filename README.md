# test-workflow

[![Release with Tag](https://github.com/netpyoung/test-workflow/actions/workflows/release_with_tag.yml/badge.svg)](https://github.com/netpyoung/test-workflow/actions/workflows/release_with_tag.yml)

- [x] tag
- [x] 체크인
- [x] Rake
- [ ] NDK
- [ ] 빌드스크립트 실행
  - [x] 릴리즈 파일
- [ ] 릴리즈 노트에 md5
- [x] 릴리즈
- [ ] 멀티플렛폼


| Platforms | Arch        | Support? | action |
| --------- | ----------- | -------- | ------ |
| Windows   | x86         |          | o      |
| Windows   | x86_64      |          | o      |
| Windows   | x86_arm64   |          | o      |
| Linux     | x86_64      |          | o      |
| macOS     | x86_64      |          | o      |
| iOS       | 64bit       |          |        |
| tvOS      | 64bit       |          |        |
| Android   | armeabi-v7a |          | o      |
| Android   | arm64_v8a   |          | o      |
| Android   | x86         |          | o      |
| Android   | x86_64      |          | o      |
| Linux     | x86         | x        |        |
| WebGL     | .           | x        | x      |
| Other     | .           | x        | x      |


## Ref

- github action context
  - <https://docs.github.com/en/actions/learn-github-actions/contexts>
- github hosted runners
  - <https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners>
- action
  - checkout : <https://github.com/actions/checkout>
  - release : <https://github.com/actions/create-release>
  - asset: <https://github.com/actions/upload-release-asset>
  - artifact
    - <https://github.com/actions/upload-artifact>
    - <https://github.com/actions/download-artifact>
  - changelog reader : <https://github.com/mindsers/changelog-reader-action>
- <https://trstringer.com/github-actions-create-release-upload-artifacts/>
- [github repo의 Release 활성화 및 Actions를 이용한 자동화 방법 - 정성태](https://www.sysnet.pe.kr/2/0/12542)
  - <https://github.com/stjeong/RefOwner/blob/master/.github/workflows/git-releases.yml>
- <https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types>
