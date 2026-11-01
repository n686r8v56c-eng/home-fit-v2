# Home Fit 2.0

React + Vite + Supabase + Cloudflare Pages. 기존 Home Fit의 코드를 교체하지 않는 독립 앱입니다.

## Setup
1. `npm install`
2. Supabase 새 프로젝트의 SQL Editor에서 `supabase/schema.sql` 실행. `hf2_*` 신규 테이블만 생성합니다.
3. Supabase Authentication → Providers에서 Email 활성화. 이메일 확인을 사용하는 경우 Auth URL Configuration에 Cloudflare 배포 주소를 Site URL/Redirect URL로 등록하세요.
4. `.env.example`을 `.env.local`로 복사한 뒤 공개 가능한 **publishable/anon** 키와 URL 입력. `service_role` / secret 키를 절대 입력하지 마세요.
5. `npm run dev` 로 확인하고 `npm run build`로 빌드.
6. Cloudflare Pages → Git 연결 → Framework `Vite`, build command `npm run build`, output `dist`, environment variables `VITE_SUPABASE_URL`/`VITE_SUPABASE_ANON_KEY`. SPA 경로는 `public/_redirects`로 처리됩니다.

## 검증 상태
- TypeScript 내장 JSX 트랜스파일 구문 검사: 통과.
- `npm install`이 실행 환경에서 시간 초과되어 종속성 설치 실패. 따라서 Vite 프로덕션 빌드와 실제 브라우저 동작 검증은 완료하지 못했습니다.
- Supabase 로그인·회원가입, SQL RLS, Cloudflare 배포는 실계정 연결 전으로 실행 검증하지 않았습니다.

## Data & safety
- 기존 Home Fit DB 테이블이나 데이터를 수정/삭제하지 않습니다.
- 새 hf2_* 테이블에 RLS가 적용됩니다.
- 데모 모드는 Supabase 설정이 없는 경우에만 표시되며 브라우저 localStorage를 사용합니다. 실사용 데이터는 연결 후 로그인 계정으로 저장하세요. 데모 데이터는 자동으로 서버 이전되지 않습니다.
- 사진 업로드 스토리지는 아직 미구현이고 이미지 URL만 지원합니다. 영상은 URL 저장 및 외부 링크 연결입니다. 시퀀스 실행은 완료 기록 중심이며 음성/메트로놈은 추후 이전 대상으로 남겨둡니다.
- 기존 Home Fit 시퀀스/사진/북마크 자동 마이그레이션 및 다른 Flow 앱 양방향 연동은 아직 하지 않았습니다.
