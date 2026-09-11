

function CheckNameUtils.contains_profanity(self, name)
  local lower = name:lower()
  for _, pat in ___MOD.ipairs(self.ESCAPED_PATTERNS) do
    if lower:find(pat) then
      return true
    end
  end
  return false
end

function CheckNameUtils.hangulEulReulJosa(self, input)
  if ___MOD._UtilLogic:IsNilorEmptyString(input) then
    return input
  end
  local lastCode
  for _, code in ___MOD.utf8.codes(input) do
    lastCode = code
  end
  if lastCode == nil then
    return input
  end
  if lastCode < 44032 or 55203 < lastCode then
    return input
  end
  local index = (lastCode - 44032) % 28
  if index == 0 then
    return input .. "를"
  end
  return input .. "을"
end

function CheckNameUtils.hangulIGaJosa(self, input)
  if ___MOD._UtilLogic:IsNilorEmptyString(input) then
    return input
  end
  local lastCode
  for _, code in ___MOD.utf8.codes(input) do
    lastCode = code
  end
  if lastCode == nil then
    return input
  end
  if lastCode < 44032 or 55203 < lastCode then
    return input
  end
  local index = (lastCode - 44032) % 28
  if index == 0 then
    return input .. "가"
  end
  return input .. "이"
end

function CheckNameUtils.is_valid_name(self, name, checkBarcode)
  local ALLOWED_PATTERN = "^[가-힣A-Za-z0-9]+$"
  if not name:match(ALLOWED_PATTERN) then
    return false, "사용할 수 없는 이름입니다."
  end
  if checkBarcode then
    local dummyStr, barcode_cnt = name:gsub("[ilI]", "")
    if 4 < barcode_cnt then
      return false, "사용할 수 없는 이름입니다."
    end
  end
  local ok, msg = self:len(name)
  if not ok then
    return false, msg
  end
  if self:contains_profanity(name) then
    return false, "사용할 수 없는 이름입니다."
  end
  return true
end

function CheckNameUtils.len(self, str)
  if self._T.ks1001Pattern == nil then
    self._T.ks1001Pattern = "^[가각간갇-갊감-갗같-객갠갤갬갭갯-갱갸갹갼걀걋걍걔걘걜거걱건걷걸걺검겁것-겆겉-게겐겔겜겝겟-겡겨-겪견겯결겸겹겻-경곁계곈곌곕곗고곡곤곧골곪곬곯-곱곳공곶과곽관괄괆괌괍괏광괘괜괠괩괬괭괴괵괸괼굄굅굇굉교굔굘굡굣구국군굳-굶굻-굽굿궁궂궈궉권궐궜궝궤궷귀귁귄귈귐귑귓규균귤그극근귿-긁금급긋긍긔기긱긴긷길긺김깁깃깅깆깊까-깎깐깔깖깜깝깟-깡깥깨깩깬깰깸깹깻-깽꺄꺅꺌꺼-꺾껀껄껌껍껏-껑께껙껜껨껫껭껴껸껼꼇꼈꼍꼐꼬꼭꼰꼲꼴꼼꼽꼿꽁-꽃꽈꽉꽐꽜꽝꽤꽥꽹꾀꾄꾈꾐꾑꾕꾜꾸꾹꾼꿀꿇-꿉꿋꿍꿎꿔꿜꿨꿩꿰꿱꿴꿸뀀뀁뀄뀌뀐뀔뀜뀝뀨끄끅끈끊끌끎끓-끕끗끙끝끼끽낀낄낌낍낏낑나-낚난낟-낢남납낫-낯낱낳-낵낸낼냄냅냇-냉냐냑냔냘냠냥너넉넋넌널넒넓넘넙넛-넝넣-넥넨넬넴넵넷-넹녀녁년녈념녑녔녕녘녜녠노녹논놀놂놈놉놋농높-놔놘놜놨뇌뇐뇔뇜뇝뇟뇨뇩뇬뇰뇹뇻뇽누눅눈눋눌눔눕눗눙눠눴눼뉘뉜뉠뉨뉩뉴뉵뉼늄늅늉느늑는늘-늚늠늡늣능늦늪늬늰늴니닉닌닐닒님닙닛닝닢다-닦단닫-닯닳-답닷-닻닿-댁댄댈댐댑댓-댕댜더-덖던덛덜덞덟덤덥덧덩덫덮데덱덴델뎀뎁뎃-뎅뎌뎐뎔뎠뎡뎨뎬도독돈돋돌돎돐돔돕돗동돛돝돠돤돨돼됐되된될됨됩됫됴두둑둔둘둠둡둣둥둬뒀뒈뒝뒤뒨뒬뒵뒷뒹듀듄듈듐듕드득든듣들듦듬듭듯등듸디딕딘딛딜딤딥딧-딪따딱딴딸땀땁땃-땅땋-땍땐땔땜땝땟-땡떠떡떤떨떪떫떰떱떳-떵떻-떽뗀뗄뗌뗍뗏-뗑뗘뗬또똑똔똘똥똬똴뙈뙤뙨뚜뚝뚠뚤뚫뚬뚱뛔뛰뛴뛸뜀뜁뜅뜨뜩뜬뜯뜰뜸뜹뜻띄띈띌띔띕띠띤띨띰띱띳띵라락란랄람랍랏-랒랖-랙랜랠램랩랫-랭랴략랸럇량러럭런럴럼럽럿-렁렇-렉렌렐렘렙렛렝려력련렬렴렵렷-령례롄롑롓로록론롤롬롭롯롱롸롼뢍뢨뢰뢴뢸룀룁룃룅료룐룔룝룟룡루룩룬룰룸룹룻룽뤄뤘뤠뤼뤽륀륄륌륏륑류륙륜률륨륩륫륭르륵른를름릅릇릉릊릍릎리릭린릴림립릿링마막만많-맒맘맙맛망맞맡맣-맥맨맬맴맵맷-맺먀먁먈먕머먹먼멀멂멈멉멋멍멎멓-멕멘멜멤멥멧-멩며멱면멸몃-명몇몌모목몫몬몰몲몸몹못몽뫄뫈뫘뫙뫼묀묄묍묏묑묘묜묠묩묫무-묶문묻-묾뭄뭅뭇뭉뭍뭏뭐뭔뭘뭡뭣뭬뮈뮌뮐뮤뮨뮬뮴뮷므믄믈믐믓미믹민믿밀밂밈밉밋-밍및밑바-반받-밟밤밥밧방밭배백밴밸뱀뱁뱃-뱅뱉뱌뱍뱐뱝버벅번벋벌벎범법벗벙벚베벡벤벧벨벰벱벳-벵벼벽변별볍볏-병볕볘볜보-볶본볼봄봅봇봉봐봔봤봬뵀뵈뵉뵌뵐뵘뵙뵤뵨부북분붇-붊붐붑붓붕붙붚붜붤붰붸뷔뷕뷘뷜뷩뷰뷴뷸븀븃븅브븍븐블븜븝븟비빅빈빌빎빔빕빗빙-빛빠빡빤빨빪빰빱빳-빵빻-빽뺀뺄뺌뺍뺏-뺑뺘뺙뺨뻐뻑뻔뻗뻘뻠뻣-뻥뻬뼁뼈뼉뼘뼙뼛-뼝뽀뽁뽄뽈뽐뽑뽕뾔뾰뿅뿌뿍뿐뿔뿜뿟뿡쀼쁑쁘쁜쁠쁨쁩삐삑삔삘삠삡삣삥사삭삯산삳-삶삼삽삿-상샅새색샌샐샘샙샛-생샤샥샨샬샴샵샷샹섀섄섈섐섕서-선섣설섦섧섬섭섯-성섶세섹센셀셈셉셋-셍셔셕션셜셤셥셧-셩셰셴셸솅소-솎손솔솖솜솝솟송솥솨솩솬솰솽쇄쇈쇌쇔쇗쇘쇠쇤쇨쇰쇱쇳쇼쇽숀숄숌숍숏숑수숙순숟술숨숩숫숭숯숱숲숴쉈쉐쉑쉔쉘쉠쉥쉬쉭쉰쉴쉼쉽쉿슁슈슉슐슘슛슝스슥슨슬슭슴습슷승시식신싣실싫-십싯싱싶싸싹싻싼쌀쌈쌉쌌쌍쌓-쌕쌘쌜쌤쌥쌨쌩썅써썩썬썰썲썸썹썼썽쎄쎈쎌쏀쏘쏙쏜쏟쏠쏢쏨쏩쏭쏴쏵쏸쐈쐐쐤쐬쐰쐴쐼쐽쑈쑤쑥쑨쑬쑴쑵쑹쒀쒔쒜쒸쒼쓩쓰쓱쓴쓸쓺쓿-씁씌씐씔씜씨씩씬씰씸씹씻씽아악안-않알-앎앓-압앗-앙앝앞애액앤앨앰앱앳-앵야약얀얄얇얌얍얏양얕얗얘얜얠얩어억언얹얻-얾엄-엊엌엎에엑엔엘엠엡엣엥여-엮연열엶엷염-영옅-예옌옐옘옙옛옜오옥온올-옮옰옳-옵옷옹옻와왁완왈왐왑왓-왕왜왝왠왬왯왱외왹왼욀욈욉욋욍요욕욘욜욤욥욧용우욱운울-욺움웁웃웅워웍원월웜웝웠웡웨웩웬웰웸웹웽위윅윈윌윔윕윗윙유육윤율윰윱윳융윷으윽은을읊음읍읏응-의읜읠읨읫이익인일-읾잃-입잇-잊잎자작잔잖-잘잚잠잡잣-잦재잭잰잴잼잽잿-쟁쟈쟉쟌쟎쟐쟘쟝쟤쟨쟬저적전절젊점접젓정젖제젝젠젤젬젭젯젱져젼졀졈졉졌졍졔조족존졸졺좀좁좃종-좇좋-좍좔좝좟좡좨좼좽죄죈죌죔죕죗죙죠죡죤죵주죽준줄-줆줌줍줏중줘줬줴쥐쥑쥔쥘쥠쥡쥣쥬쥰쥴쥼즈즉즌즐즘즙즛증지직진짇질짊짐집짓징짖짙짚짜짝짠짢짤짧짬짭짯-짱째짹짼쨀쨈쨉쨋-쨍쨔쨘쨩쩌쩍쩐쩔쩜쩝쩟-쩡쩨쩽쪄쪘쪼쪽쫀쫄쫌쫍쫏쫑쫓쫘쫙쫠쫬쫴쬈쬐쬔쬘쬠쬡쭁쭈쭉쭌쭐쭘쭙쭝쭤쭸쭹쮜쮸쯔쯤쯧쯩찌찍찐찔찜찝찡찢찧-착찬찮찰참찹찻-찾채책챈챌챔챕챗-챙챠챤챦챨챰챵처척천철첨첩첫-청체첵첸첼쳄쳅쳇쳉쳐쳔쳤쳬쳰촁초촉촌촐촘촙촛총촤촨촬촹최쵠쵤쵬쵭쵯쵱쵸춈추축춘출춤춥춧충춰췄췌췐취췬췰췸췹췻췽츄츈츌츔츙츠측츤츨츰츱츳층치칙친칟-칡침칩칫칭카칵칸칼캄캅캇캉캐캑캔캘캠캡캣-캥캬캭컁커컥컨컫컬컴컵컷-컹케켁켄켈켐켑켓켕켜켠켤켬켭켯-켱켸코콕콘콜콤콥콧콩콰콱콴콸쾀쾅쾌쾡쾨쾰쿄쿠쿡쿤쿨쿰쿱쿳쿵쿼퀀퀄퀑퀘퀭퀴퀵퀸퀼큄큅큇큉큐큔큘큠크큭큰클큼큽킁키킥킨킬킴킵킷킹타탁탄탈탉탐탑탓-탕태택탠탤탬탭탯-탱탸턍터턱턴털턺텀텁텃-텅테텍텐텔템텝텟텡텨텬텼톄톈토톡톤톨톰톱톳통톺톼퇀퇘퇴퇸툇툉툐투툭툰툴툼툽툿퉁퉈퉜퉤튀튁튄튈튐튑튕튜튠튤튬튱트특튼튿틀틂틈틉틋틔틘틜틤틥티틱틴틸팀팁팃팅파-팎판팔팖팜팝팟-팡팥패팩팬팰팸팹팻-팽퍄퍅퍼퍽펀펄펌펍펏-펑페펙펜펠펨펩펫펭펴편펼폄폅폈평폐폘폡폣포폭폰폴폼폽폿퐁퐈퐝푀푄표푠푤푭푯푸푹푼푿풀풂품풉풋풍풔풩퓌퓐퓔퓜퓟퓨퓬퓰퓸퓻퓽프픈플픔픕픗피픽핀필핌핍핏핑하학한할핥함합핫항해핵핸핼햄햅햇-행햐향허헉헌헐헒험헙헛헝헤헥헨헬헴헵헷헹혀혁현혈혐협혓-형혜혠혤혭호혹혼홀홅홈홉홋홍홑화확환활홧황홰홱홴횃횅회획횐횔횝횟횡효횬횰횹횻후훅훈훌훑훔훗훙훠훤훨훰훵훼훽휀휄휑휘휙휜휠휨휩휫휭휴휵휸휼흄흇흉흐흑흔흖-흙흠흡흣흥흩희흰흴흼흽힁히힉힌힐힘힙힛힝]$"
  end
  if self._T.ks1001Allow == nil then
    local body = ___MOD.string.sub(self._T.ks1001Pattern, 3, -3)
    local tokens = {}
    for _, code in ___MOD.utf8.codes(body) do
      tokens[#tokens + 1] = code
    end
    local allow = {}
    local i = 1
    while i <= #tokens do
      local startCp = tokens[i]
      if i + 2 <= #tokens and tokens[i + 1] == 45 then
        local endCp = tokens[i + 2]
        if startCp <= endCp then
          for code = startCp, endCp do
            allow[code] = true
          end
        else
          allow[startCp] = true
          allow[endCp] = true
        end
        i = i + 3
      else
        if startCp ~= 45 then
          allow[startCp] = true
        end
        i = i + 1
      end
    end
    self._T.ks1001Allow = allow
  end
  local allow = self._T.ks1001Allow
  local len = 0
  for _, cp in ___MOD.utf8.codes(str) do
    if cp <= 127 then
      len = len + 1
    elseif 44032 <= cp and cp <= 55203 then
      if not allow[cp] then
        return nil, "사용할 수 없는 이름입니다."
      end
      len = len + 2
    else
      return nil, "사용할 수 없는 이름입니다."
    end
    if 12 < len then
      return nil, "이름이 너무 깁니다."
    end
  end
  if len < 4 then
    return nil, "이름이 너무 짧습니다."
  end
  return len
end

function CheckNameUtils.OnBeginPlay(self)
  self.ESCAPED_PATTERNS = {}
  local ds = ___MOD._DataService:GetTable("BanNickname")
  if ds == nil then
    ___MOD.log_warning("[CheckNameUtils] BanNickname 데이터셋을 찾지 못했습니다.")
    return
  end
  local count = ds:GetRowCount()
  local get = ds.GetCell

  local function esc(p)
    return (___MOD.string.gsub(p, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
  end

  for i = 1, count do
    local before = get(ds, i, 1)
    if not ___MOD._UtilLogic:IsNilorEmptyString(before) then
      self.ESCAPED_PATTERNS[#self.ESCAPED_PATTERNS + 1] = esc(before):lower()
    end
  end
end
