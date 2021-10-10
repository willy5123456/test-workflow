# test-workflow

- [x] tag
- [x] 체크인
- [ ] 빌드스크립트 실행
  - [ ] md5 생성
  - [ ] 릴리즈 파일
- [ ] 릴리즈 노트에 md5
- [ ] 릴리즈
- [ ] 멀티플렛폼 메트릭스

## Ref

- action
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
