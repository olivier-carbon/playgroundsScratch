openapi: 3.0.0

info:
title: Arkera API
version: v0

servers:
- url: https://alfred-staging.arkera.co/
description: Staging server
- url: https://alfred.arkera.co/
description: Production server

paths:

/users/{userId}/login:
post:
summary: login.
operationId: login
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/LoginRequestProto'
responses:
'200':
description: Successful login.
content:
'*/*' :
schema:
$ref: '#/components/schemas/LoginResponseProto'
'401':
$ref: '#/components/responses/UnauthorizedError'
'500':
$ref: '#/components/schemas/CarbonException'

/users/{userId}/logout:
post:
summary: logout.
operationId: logout
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/LogoutRequestProto'
responses:
'200':
description: Successful logout.
content:
'*/*' :
schema:
$ref: '#/components/schemas/LogoutResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'

security:
# TODO: define scopes
- bearerAuth: []

/users/{userId}/interests:
get:
summary: View user's interests.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/GetInterestsRequestProto'
responses:
'200':
description: Got user's interests.
content:
'*/*' :
schema:
$ref: '#/components/schemas/GetInterestsResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []
post:
summary: Add entity to user's interests.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/PostInterestRequestProto'
responses:
'200':
description: Added entity to user's interests.
content:
'*/*' :
schema:
$ref: '#/components/schemas/PostInterestResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []
delete:
summary: Remove entity from user's interests.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/DeleteInterestRequestProto'
responses:
'200':
description: Removed entity from user's interests.
content:
'*/*' :
schema:
$ref: '#/components/schemas/DeleteInterestResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/users/{userId}/conversations:
post:
summary: Post a conversation.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/PostConversationRequestProto'
responses:
'200':
description: Added a conversation.
content:
'*/*' :
schema:
$ref: '#/components/schemas/PostConversationResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/users/{userId}/conversations/{conversationId}/score-instruments:
post:
summary: Score instruments for conversation.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/ScoreConversationInstrumentsRequestProto'
responses:
'200':
description: Retrieved scored instruments for conversation.
content:
'*/*' :
schema:
$ref: '#/components/schemas/ScoreConversationInstrumentsResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/users/{userId}/statement-feeds:
post:
summary: Post/refresh statement feeds id.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/PostStatementFeedRequestProto'
responses:
'200':
description: Get statements.
content:
'*/*' :
schema:
$ref: '#/components/schemas/PostStatementFeedResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/statements/{statementId}:
get:
summary: Get statement.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/GetStatementRequestProto'
responses:
'200':
description: Got a statement.
content:
'*/*' :
schema:
$ref: '#/components/schemas/GetStatementResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/assets/{assetId}/similar-assets:
get:
summary: Score assets.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/GetSimilarAssetsRequestProto'
responses:
'200':
description: Score assets.
content:
'*/*' :
schema:
$ref: '#/components/schemas/GetSimilarAssetsResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/assets/{assetId}:
get:
summary: Get asset.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/GetAssetRequestProto'
responses:
'200':
description: Got a asset.
content:
'*/*':
schema:
$ref: '#/components/schemas/GetAssetResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/assets/{assetId}/prices:
get:
summary: Get asset prices.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/GetAssetPricesRequestProto'
responses:
'200':
description: Got asset prices.
content:
'*/*':
schema:
$ref: '#/components/schemas/GetAssetPricesResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

/users/{userId}/events:
post:
summary: Process an event.
requestBody:
content:
'*/*':
schema:
$ref: '#/components/schemas/PostEventRequestProto'
responses:
'200':
description: Processed an event.
content:
'*/*':
schema:
$ref: '#/components/schemas/PostEventResponseProto'
'500':
$ref: '#/components/schemas/CarbonException'
security:
- bearerAuth: []

components:

schemas:

LoginRequestProto:
type: object
properties:
userId:
type: integer
format: int64
password:
type: string

LoginResponseProto:
type: object
properties:
token:
type: string
lastLoginDate:
type: string
format: date-time
deviceInfo:
$ref: '#/components/schemas/DeviceInfoProto'

DeviceInfoProto:
type: object
properties:
appBuildVersion:
type: integer
format: int64
deviceModel:
type: string
devicePlatform:
type: string
devicePlatformVersion:
type: string

LogoutRequestProto:
type: object
properties:
userId:
type: integer
format: int64
minimum: 1
readSession:
type: string

LogoutResponseProto:
type: object

GetInterestsRequestProto:
type: object
properties:
userId:
type: integer
format: int64

GetInterestsResponseProto:
type: object
properties:
interests:
type: array
items:
$ref: '#/components/schemas/InterestProto'

PostInterestRequestProto:
type: object
properties:
userId:
type: integer
format: int64
entityId:
type: integer
format: int64

PostInterestResponseProto:
type: object
properties:
interest:
$ref: '#components/schemas/InterestProto'

DeleteInterestRequestProto:
type: object
properties:
userId:
type: integer
format: int64
entityId:
type: integer

DeleteInterestResponseProto:
type: object

PostConversationRequestProto:
type: object
properties:
userId:
type: integer
format: int64

PostConversationResponseProto:
type: object
properties:
conversationId:
type: integer
format: int64

ConversationProto:
type: object
properties:
conversationId:
type: integer
format: int64
items:
type: array
items:
$ref: '#/components/schemas/ConversationProto.ItemProto'

ConversationProto.ItemProto:
type: object
properties:
resource:
oneOf:
- $ref: '#components/schemas/ArticleProto'
- $ref: '#components/schemas/LabelProto'
- $ref: '#components/schemas/StatementProto'
date:
type: string
format: date-time

ScoreConversationInstrumentsRequestProto:
type: object
properties:
userId:
type: integer
format: int64
conversationId:
type: integer
format: int64
pageType:
type: string
pageId:
type: integer
format: int64

ScoreConversationInstrumentsResponseProto:
type: object
properties:
scoredInstruments:
$ref: '#/components/schemas/ScoredInstrumentProto'
conversation:
$ref: '#/components/schemas/ConversationProto'

PostStatementFeedRequestProto:
description: Post Feed Statements Request Proto
type: object
properties:
userId:
type: integer
format: int64
limit:
type: integer
format: int32
minimum: 1
maximum: 25
default: 25

PostStatementFeedResponseProto:
description: Post Feed Statements Response Proto
type: object
properties:
statementFeed:
$ref: '#/components/schemas/StatementFeedProto'

StatementFeedProto:
description: Model Statement Feed Response Proto
type: object
properties:
statementFeedId:
type: integer
format: int64
offset:
type: integer
format: int32
items:
type: array
items:
$ref: '#/components/schemas/StatementFeedProto.ItemProto'

GetStatementFeedItemsRequestProto:
description: Get Feed Statements Request Proto
type: object
properties:
userId:
type: integer
format: int64
statementFeedId:
type: integer
format: int64
limit:
type: integer
format: int32
minimum: 1
maximum: 25
default: 25
offset:
type: integer
format: int32

GetStatementFeedItemsResponseProto:
description: Get Feed Statements Response Proto
type: object
properties:
items:
type: array
items:
$ref: '#/components/schemas/StatementFeedProto.ItemProto'

StatementFeedProto.ItemProto:
description: Model Scored Statement Proto
type: object
properties:
scoredStatement:
$ref: '#/components/schemas/ScoredStatementProto'

ScoredStatementProto:
description: Model Scored Statement Proto
type: object
properties:
statement:
$ref: '#/components/schemas/StatementProto'
score:
type: number
format: float

GetStatementRequestProto:
description: Get Statement Request Proto
type: object
properties:
statementId:
type: integer
format: int64

GetStatementResponseProto:
description: Get Statement Response Proto
type: object
properties:
statement:
$ref: '#/components/schemas/StatementProto'

StatementProto:
description: Model Statement object
type: object
properties:
statementId:
type: integer
format: int64
source:
type: string
text:
type: string
statementType:
type: string
publishDate:
type: string
format: date-time
article:
$ref: '#/components/schemas/ArticleProto'
labels:
type: array
items:
$ref: '#/components/schemas/LabelProto'

ArticleProto:
description: Model Article object
type: object
properties:
articleId:
type: integer
format: int64
articleType:
type: string
isServable:
type: boolean
title:
type: string
url:
type: string
imageUrl:
type: string
htmlContent:
type: string
publishDate:
type: string
format: date-time
expiryDate:
type: string
format: date-time

GetSimilarAssetsRequestProto:
type: object
properties:
assetId:
type: integer
format: int64
limit:
type: integer
format: int32
offset:
type: integer
format: int32
summarised:
type: boolean

GetSimilarAssetsResponseProto:
description: Get Assets Response Proto
type: object
properties:
assets:
type: array
items:
$ref: '#/components/schemas/ScoredAssetProto'

GetAssetRequestProto:
type: object
properties:
assetId:
type: integer
format: int64
summarised:
type: boolean

GetAssetResponseProto:
type: object
properties:
asset:
$ref: '#/components/schemas/AssetProto'

GetAssetPricesRequestProto:
type: object
properties:
assetId:
type: integer
format: int64
minDate:
type: string
format: date-time
maxDate:
type: string
format: date-time
fillGaps:
type: boolean

GetAssetPricesResponseProto:
type: object
properties:
assetsPrices:
type: array
items:
$ref: '#/components/schemas/AssetPriceProto'

AssetPriceProto:
type: object
properties:
date:
type: string
format: date-time
closePrice:
type: number
format: float
openPrice:
type: number
format: float
highPrice:
type: number
format: float
lowPrice:
type: number
format: float
adjustedPrice:
type: number
format: float

ScoredInstrumentProto:
type: object
properties:
instrument:
$ref: '#/components/schemas/InstrumentProto'
score:
type: number
format: float
reasons:
type: array
items:
$ref: '#/components/schemas/ReasonProto'

ReasonProto:
type: object
properties:
name:
type: string
score:
type: number
format: float

ScoredAssetProto:  # TODO(rikhil): remove this when assets have been renamed to instruments
description: Model Scored Asset Proto
properties:
asset:
$ref: '#/components/schemas/AssetProto'
score:
type: number
format: float

InstrumentProto:
description: Model Asset Proto
oneOf:
- $ref: '#/components/schemas/EtpProto'

AssetProto:  # TODO(rikhil): remove this when assets have been renamed to instruments
description: Model Asset Proto
oneOf:
- $ref: '#/components/schemas/EtpProto'

PostEventRequestProto:
description: Post Event Request Proto
type: object
properties:
userId:
type: integer
format: int64
date:
type: string
format: date-time
eventType:
type: string
enum: [
'client_article_open',
'client_article_dismiss',
'client_article_read',
'client_article_rate',
'client_button_click',
'client_object_open',
'client_statement_feed_item_dismiss',
'client_statement_feed_item_explore'
]
data:
type: string
format: json

PostEventResponseProto:
description: Post Event Response Proto
type: object

InstrumentTypeProto:
type: object
properties:
instrumentTypeId:
type: integer
format: int64
name:
type: string

EtpProto:
description: Model ETP Proto
type: object
properties:
assetId:
type: integer
format: int64
isin:
type: string
instrumentType:
$ref: '#/components/schemas/InstrumentTypeProto'
symbol:
type: string
shortName:
type: string
fullName:
type: string
description:
type: string
underlyingTicker:
type: string
underlyingLongName:
type: string
exchange:
$ref: '#/components/schemas/ExchangeProto'
currency:
$ref: '#/components/schemas/CurrencyProto'
etpData:
$ref: '#/components/schemas/EtpProto.EtpDataProto'

EtpProto.EtpDataProto:
type: object
properties:
assetsUsd:
type: integer
format: int64
expenseRatio:
type: number
format: float
averageBidAsk:
type: number
format: float
oneYearNavTrackError:
type: number
format: float
forexHedgedFlag:
type: boolean
activelyManaged:
type: boolean
shortFlag:
type: boolean
leverageFlag:
type: boolean
leverageMultiplier:
type: number
format: float
commoditiesUnderlying:
type: string
investedRegion:
$ref: '#/components/schemas/RegionProto'
investedCountry:
$ref: '#/components/schemas/CountryProto'
assetType:
$ref: '#/components/schemas/EtpProto.EtpDataProto.AssetTypeProto'
marketCapitalisation:
$ref: '#/components/schemas/EtpProto.EtpDataProto.MarketCapitalisationProto'
equityStyle:
$ref: '#/components/schemas/EtpProto.EtpDataProto.EquityStyleCategoriesProto'
fixedIncomeSubtype:
$ref: '#/components/schemas/EtpProto.EtpDataProto.FixedIncomeSubtypeProto'
fixedIncomeStyle:
$ref: '#/components/schemas/EtpProto.EtpDataProto.FixedIncomeStyleProto'
fixedIncomeMaturity:
$ref: '#/components/schemas/EtpProto.EtpDataProto.FixedIncomeMaturityProto'
fixedIncomeCreditQuality:
$ref: '#/components/schemas/EtpProto.EtpDataProto.FixedIncomeCreditQualityProto'
forexUnderlying:
$ref: '#/components/schemas/EtpProto.EtpDataProto.ForexUnderlyingProto'
investedAssetClasses:
type: array
items:
$ref: '#components/schemas/EtpProto.EtpDataProto.InvestedAssetClassProto'
investedEquityStyles:
type: array
items:
$ref: '#/components/schemas/EtpProto.EtpDataProto.InvestedEquityStyleProto'
investedIndustries:
type: array
items:
$ref: '#components/schemas/EtpProto.EtpDataProto.InvestedIndustryProto'
investedMarketCapitalizationSizes:
type: array
items:
$ref: '#components/schemas/EtpProto.EtpDataProto.InvestedMarketCapitalizationSizeProto'
investedFixedIncomeIssuerTypes:
type: array
items:
$ref: '#components/schemas/EtpProto.EtpDataProto.InvestedFixedIncomeIssuerTypeProto'
investedFixedIncomeSecurityTypes:
type: array
items:
$ref: '#components/schemas/EtpProto.EtpDataProto.InvestedFixedIncomeSecurityTypeProto'

EtpProto.EtpDataProto.InvestedAssetClassProto:
type: object
properties:
assetClass:
$ref: '#/components/schemas/AssetClassProto'
weight:
type: number
format: float

EtpProto.EtpDataProto.InvestedEquityStyleProto:
type: object
properties:
equityStyle:
$ref: '#/components/schemas/EquityStyleProto'
weight:
type: number
format: float

EtpProto.EtpDataProto.InvestedFixedIncomeIssuerTypeProto:
type: object
properties:
fixedIncomeIssuerType:
$ref: '#/components/schemas/FixedIncomeIssuerTypeProto'
weight:
type: number
format: float

EtpProto.EtpDataProto.InvestedFixedIncomeSecurityTypeProto:
type: object
properties:
fixedIncomeSecurityType:
$ref: '#/components/schemas/FixedIncomeSecurityTypeProto'
weight:
type: number
format: float

EtpProto.EtpDataProto.InvestedIndustryProto:
type: object
properties:
industry:
$ref: '#/components/schemas/IndustryProto'
weight:
type: number
format: float

EtpProto.EtpDataProto.InvestedMarketCapitalizationSizeProto:
type: object
properties:
marketCapitalisationSize:
$ref: '#/components/schemas/MarketCapitalizationSizeProto'
weight:
type: number
format: float

EtpProto.EtpDataProto.AssetTypeProto:
type: object
properties:
fixedIncome:
type: number
format: float
equity:
type: number
format: float
reit:
type: number
format: float
volatility:
type: number
format: float
forex:
type: number
format: float
moneyMarket:
type: number
format: float
hedgeFund:
type: number
format: float
privateEquity:
type: number
format: float
commodity:
type: number
format: float

EtpProto.EtpDataProto.MarketCapitalisationProto:
type: object
properties:
largeCap:
type: number
format: float
midCap:
type: number
format: float
smallCap:
type: number
format: float

EtpProto.EtpDataProto.EquityStyleCategoriesProto:
properties:
dividend:
type: number
format: float
value:
type: number
format: float
growth:
type: number
format: float
activebeta:
type: number
format: float
momentum:
type: number
format: float
fundamental:
type: number
format: float
lowVolatility:
type: number
format: float

EtpProto.EtpDataProto.FixedIncomeSubtypeProto:
type: object
properties:
government:
type: number
format: float
corporate:
type: number
format: float
mortgage:
type: number
format: float
convertible:
type: number
format: float
loans:
type: number
format: float
preferred:
type: number
format: float
municipal:
type: number
format: float

EtpProto.EtpDataProto.FixedIncomeStyleProto:
type: object
properties:
creditSpread:
type: number
format: float
floatingRate:
type: number
format: float
inflationLinked:
type: number
format: float
durationAndCredit:
type: number
format: float

EtpProto.EtpDataProto.FixedIncomeMaturityProto:
type: object
properties:
longTerm:
type: number
format: float
shortTerm:
type: number
format: float
intermediateTerm:
type: number
format: float

EtpProto.EtpDataProto.FixedIncomeCreditQualityProto:
type: object
properties:
investmentGrade:
type: number
format: float
highYield:
type: number
format: float

EtpProto.EtpDataProto.ForexUnderlyingProto:
type: object
properties:
long:
type: string
short:
type: string

AssetClassProto:
type: object
properties:
assetClassId:
type: integer
format: int64
name:
type: string

EquityStyleProto:
type: object
properties:
equityStyleId:
type: integer
format: int64
name:
type: string

FixedIncomeIssuerTypeProto:
type: object
properties:
fixedIncomeIssuerTypeId:
type: integer
format: int64
name:
type: string

FixedIncomeSecurityTypeProto:
type: object
properties:
fixedIncomeSecurityTypeId:
type: integer
format: int64
name:
type: string

MarketCapitalizationSizeProto:
type: object
properties:
marketCapitalizationSizeId:
type: integer
format: int64
name:
type: string

RegionProto:
type: object
properties:
regionId:
type: integer
format: int64
name:
type: string
code:
type: string

InterestProto:
description: Model Interest Proto
properties:
date:
type: string
format: date-time
entity:
$ref: '#components/schemas/EntityProto'

EntityProto:
description: Model Entity Prto
oneOf:
- $ref: '#components/schemas/PersonProto'
- $ref: '#components/schemas/ThemeProto'
- $ref: '#components/schemas/CompanyProto'

PersonProto:
description: Model Person Proto
type: object
properties:
personId:
type: integer
format: int64
name:
type: string
isInfluencer:
type: boolean
imageUrl:
type: string
role:
type: string
description:
type: string
dbpediaUrl:
type: string
twitterHandle:
type: string

ThemeProto:
description: Model Theme Proto
type: object
properties:
themeId:
type: integer
format: int64
name:
type: string
description:
type: string
imageUrl:
type: string
isActive:
type: boolean

CompanyProto:
description: Model Company Proto
type: object
properties:
companyId:
type: integer
format: int64
name:
type: string
description:
type: string
country:
$ref: '#components/schemas/CountryProto'
industry:
$ref: '#components/schemas/IndustryProto'
primaryAsset:
$ref: '#components/schemas/EquityProto'
imageurl:
type: string
isPublic:
type: boolean

CurrencyProto:
description: Model Currency Proto
type: object
properties:
currencyId:
type: integer
format: int64
name:
type: string
code:
type: string
symbol:
type: string
flagImageurl:
type: string

ExchangeProto:
description: Model Exchange Proto
type: object
properties:
exchangeId:
type: integer
format: int64
name:
type: string
mic:
type: string
yahooSuffix:
type: string

CountryProto:
description: Model Country Proto
type: object
properties:
countryId:
type: integer
format: int64
name:
type: string
code:
type: string
flagImageUrl:
type: string

IndustryProto:
description: Model Industry Proto
type: object
properties:
industryId:
type: integer
format: int64
name:
type: string
trbcCode:
type: integer
format: int64
level:
type: integer
format: int64
parentIndustry:
$ref: '#components/schemas/IndustryProto'

EquityProto:
description: Model Equity Proto
type: object
properties:
equityId:
type: integer
format: int64
ticker:
type: string
name:
type: string
ric:
type: string
exchange:
$ref: '#components/schemas/ExchangeProto'
currency:
$ref: '#components/schemas/CurrencyProto'
industry:
$ref: '#components/schemas/IndustryProto'
country:
$ref: '#components/schemas/CountryProto'

CompositeLabelProto:
description: Composite Label Proto
type: object
properties:
labelId:
type: integer
format: int64
name:
type: string
labelType:
type: string
primitiveLabels:
type: array
items:
$ref: '#/components/schemas/PrimitiveLabelProto'

PrimitiveLabelProto:
description: Primitive Label Proto
type: object
properties:
labelId:
type: integer
format: int64
name:
type: string
resourceType:
type: string
resourceId:
type: string

LabelProto:
description: Label Proto
oneOf:
- $ref: '#components/schemas/PrimitiveLabelProto'
- $ref: '#components/schemas/CompositeLabelProto'

CarbonException:
type: object
required:
- message
- statusCode
- exceptionType
properties:
message:
type: string
statusCode:
type: integer
format: int32
exceptionType:
type: string

securitySchemes:
bearerAuth:
type: http
scheme: bearer
bearerFormat: JWT

responses:
UnauthorizedError:
description: Access token is missing or invalid
