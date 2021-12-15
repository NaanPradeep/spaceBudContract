
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE NoImplicitPrelude          #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}

import           Prelude
import           System.Environment

import           Cardano.Api
import Cardano.Ledger.Alonzo.Language (Language (PlutusV1), ppLanguage)
import Cardano.Ledger.Alonzo.PParams (encodeLangViews, LangDepView(..))
import Cardano.Ledger.Serialization
  (    mapToCBOR,
  )
import           Cardano.Api.Shelley

import qualified Cardano.Ledger.Alonzo.Data as Alonzo
import qualified Plutus.V1.Ledger.Api as Plutus
import           Data.Aeson (encode)
import           Cardano.Binary (ToCBOR (toCBOR),serialize', serializeEncoding',encodeNull,serializeEncoding,Encoding)
import qualified Data.ByteString.Short as SBS
import qualified Data.ByteString.Lazy  as LBS
import qualified Data.ByteString as B
import qualified Data.ByteString.UTF8 as U
import qualified Data.Text as T
import qualified Data.Map as Map
import qualified Data.Set as Set
import           Cardano.PlutusExample.Trade (tradeSBS, tradeSerialised, TradeDatum(..), TradeDetails(..), TradeAction(..))
import Numeric (showHex)
import GHC.Generics
import qualified Data.ByteString.Base16 as B16


main :: IO ()
main = do
  args <- getArgs
  let nargs = length args
  let scriptnum = if nargs > 0 then read (args!!0) else 42
  let scriptname = if nargs > 1 then args!!1 else  "result.plutus"
  putStrLn $ "Writing output to: " ++ scriptname
  writePlutusScript scriptnum scriptname tradeSerialised tradeSBS


c :: MyCostModel
c = MyCostModel $ Map.fromList [("sha2_256-memory-arguments", 4), ("equalsString-cpu-arguments-constant", 1000), ("cekDelayCost-exBudgetMemory", 100), ("lessThanEqualsByteString-cpu-arguments-intercept", 103599), ("divideInteger-memory-arguments-minimum", 1), ("appendByteString-cpu-arguments-slope", 621), ("blake2b-cpu-arguments-slope", 29175), ("iData-cpu-arguments", 150000), ("encodeUtf8-cpu-arguments-slope", 1000), ("unBData-cpu-arguments", 150000), ("multiplyInteger-cpu-arguments-intercept", 61516), ("cekConstCost-exBudgetMemory", 100), ("nullList-cpu-arguments", 150000), ("equalsString-cpu-arguments-intercept", 150000), ("trace-cpu-arguments", 150000), ("mkNilData-memory-arguments", 32), ("lengthOfByteString-cpu-arguments", 150000), ("cekBuiltinCost-exBudgetCPU", 29773), ("bData-cpu-arguments", 150000), ("subtractInteger-cpu-arguments-slope", 0), ("unIData-cpu-arguments", 150000), ("consByteString-memory-arguments-intercept", 0), ("divideInteger-memory-arguments-slope", 1), ("divideInteger-cpu-arguments-model-arguments-slope", 118), ("listData-cpu-arguments", 150000), ("headList-cpu-arguments", 150000), ("chooseData-memory-arguments", 32), ("equalsInteger-cpu-arguments-intercept", 136542), ("sha3_256-cpu-arguments-slope", 82363), ("sliceByteString-cpu-arguments-slope", 5000), ("unMapData-cpu-arguments", 150000), ("lessThanInteger-cpu-arguments-intercept", 179690), ("mkCons-cpu-arguments", 150000), ("appendString-memory-arguments-intercept", 0), ("modInteger-cpu-arguments-model-arguments-slope", 118), ("ifThenElse-cpu-arguments", 1), ("mkNilPairData-cpu-arguments", 150000), ("lessThanEqualsInteger-cpu-arguments-intercept", 145276), ("addInteger-memory-arguments-slope", 1), ("chooseList-memory-arguments", 32), ("constrData-memory-arguments", 32), ("decodeUtf8-cpu-arguments-intercept", 150000), ("equalsData-memory-arguments", 1), ("subtractInteger-memory-arguments-slope", 1), ("appendByteString-memory-arguments-intercept", 0), ("lengthOfByteString-memory-arguments", 4), ("headList-memory-arguments", 32), ("listData-memory-arguments", 32), ("consByteString-cpu-arguments-intercept", 150000), ("unIData-memory-arguments", 32), ("remainderInteger-memory-arguments-minimum", 1), ("bData-memory-arguments", 32), ("lessThanByteString-cpu-arguments-slope", 248), ("encodeUtf8-memory-arguments-intercept", 0), ("cekStartupCost-exBudgetCPU", 100), ("multiplyInteger-memory-arguments-intercept", 0), ("unListData-memory-arguments", 32), ("remainderInteger-cpu-arguments-model-arguments-slope", 118), ("cekVarCost-exBudgetCPU", 29773), ("remainderInteger-memory-arguments-slope", 1), ("cekForceCost-exBudgetCPU", 29773), ("sha2_256-cpu-arguments-slope", 29175), ("equalsInteger-memory-arguments", 1), ("indexByteString-memory-arguments", 1), ("addInteger-memory-arguments-intercept", 1), ("chooseUnit-cpu-arguments", 150000), ("sndPair-cpu-arguments", 150000), ("cekLamCost-exBudgetCPU", 29773), ("fstPair-cpu-arguments", 150000), ("quotientInteger-memory-arguments-minimum", 1), ("decodeUtf8-cpu-arguments-slope", 1000), ("lessThanInteger-memory-arguments", 1), ("lessThanEqualsInteger-cpu-arguments-slope", 1366), ("fstPair-memory-arguments", 32), ("modInteger-memory-arguments-intercept", 0), ("unConstrData-cpu-arguments", 150000), ("lessThanEqualsInteger-memory-arguments", 1), ("chooseUnit-memory-arguments", 32), ("sndPair-memory-arguments", 32), ("addInteger-cpu-arguments-intercept", 197209), ("decodeUtf8-memory-arguments-slope", 8), ("equalsData-cpu-arguments-intercept", 150000), ("mapData-cpu-arguments", 150000), ("mkPairData-cpu-arguments", 150000), ("quotientInteger-cpu-arguments-constant", 148000), ("consByteString-memory-arguments-slope", 1), ("cekVarCost-exBudgetMemory", 100), ("indexByteString-cpu-arguments", 150000), ("unListData-cpu-arguments", 150000), ("equalsInteger-cpu-arguments-slope", 1326), ("cekStartupCost-exBudgetMemory", 100), ("subtractInteger-cpu-arguments-intercept", 197209), ("divideInteger-cpu-arguments-model-arguments-intercept", 425507), ("divideInteger-memory-arguments-intercept", 0), ("cekForceCost-exBudgetMemory", 100), ("blake2b-cpu-arguments-intercept", 2477736), ("remainderInteger-cpu-arguments-constant", 148000), ("tailList-cpu-arguments", 150000), ("encodeUtf8-cpu-arguments-intercept", 150000), ("equalsString-cpu-arguments-slope", 1000), ("lessThanByteString-memory-arguments", 1), ("multiplyInteger-cpu-arguments-slope", 11218), ("appendByteString-cpu-arguments-intercept", 396231), ("lessThanEqualsByteString-cpu-arguments-slope", 248), ("modInteger-memory-arguments-slope", 1), ("addInteger-cpu-arguments-slope", 0), ("equalsData-cpu-arguments-slope", 10000), ("decodeUtf8-memory-arguments-intercept", 0), ("chooseList-cpu-arguments", 150000), ("constrData-cpu-arguments", 150000), ("equalsByteString-memory-arguments", 1), ("cekApplyCost-exBudgetCPU", 29773), ("quotientInteger-memory-arguments-slope", 1), ("verifySignature-cpu-arguments-intercept", 3345831), ("unMapData-memory-arguments", 32), ("mkCons-memory-arguments", 32), ("sliceByteString-memory-arguments-slope", 1), ("sha3_256-memory-arguments", 4), ("ifThenElse-memory-arguments", 1), ("mkNilPairData-memory-arguments", 32), ("equalsByteString-cpu-arguments-slope", 247), ("appendString-cpu-arguments-intercept", 150000), ("quotientInteger-cpu-arguments-model-arguments-slope", 118), ("cekApplyCost-exBudgetMemory", 100), ("equalsString-memory-arguments", 1), ("multiplyInteger-memory-arguments-slope", 1), ("cekBuiltinCost-exBudgetMemory", 100), ("remainderInteger-memory-arguments-intercept", 0), ("sha2_256-cpu-arguments-intercept", 2477736), ("remainderInteger-cpu-arguments-model-arguments-intercept", 425507), ("lessThanEqualsByteString-memory-arguments", 1), ("tailList-memory-arguments", 32), ("mkNilData-cpu-arguments", 150000), ("chooseData-cpu-arguments", 150000), ("unBData-memory-arguments", 32), ("blake2b-memory-arguments", 4), ("iData-memory-arguments", 32), ("nullList-memory-arguments", 32), ("cekDelayCost-exBudgetCPU", 29773), ("subtractInteger-memory-arguments-intercept", 1), ("lessThanByteString-cpu-arguments-intercept", 103599), ("consByteString-cpu-arguments-slope", 1000), ("appendByteString-memory-arguments-slope", 1), ("trace-memory-arguments", 32), ("divideInteger-cpu-arguments-constant", 148000), ("cekConstCost-exBudgetCPU", 29773), ("encodeUtf8-memory-arguments-slope", 8), ("quotientInteger-cpu-arguments-model-arguments-intercept", 425507), ("mapData-memory-arguments", 32), ("appendString-cpu-arguments-slope", 1000), ("modInteger-cpu-arguments-constant", 148000), ("verifySignature-cpu-arguments-slope", 1), ("unConstrData-memory-arguments", 32), ("quotientInteger-memory-arguments-intercept", 0), ("equalsByteString-cpu-arguments-constant", 150000), ("sliceByteString-memory-arguments-intercept", 0), ("mkPairData-memory-arguments", 32), ("equalsByteString-cpu-arguments-intercept", 112536), ("appendString-memory-arguments-slope", 1), ("lessThanInteger-cpu-arguments-slope", 497), ("modInteger-cpu-arguments-model-arguments-intercept", 425507), ("modInteger-memory-arguments-minimum", 1), ("sha3_256-cpu-arguments-intercept", 0), ("verifySignature-memory-arguments", 1), ("cekLamCost-exBudgetMemory", 100), ("sliceByteString-cpu-arguments-intercept", 150000)]


newtype MyCostModel = MyCostModel (Map.Map T.Text Integer)
  deriving (Eq, Generic, Show, Ord)

instance ToCBOR MyCostModel where
  toCBOR (MyCostModel cm) = toCBOR $ Map.elems cm

myencodeLangViews :: Set.Set LangDepView -> Encoding
myencodeLangViews views =
  toCBOR $ Map.fromList (unLangDepView <$> Set.toList views)
  where
    unLangDepView (LangDepView a b) = (a, b)

testCostModel :: MyCostModel
testCostModel = MyCostModel $ Map.fromList [("a", 500)]

langView = LangDepView (serialize' lang) (serializeEncoding' $ maybe encodeNull toCBOR $ Just c)
langViews = Set.fromList [langView]
encodedViews = serializeEncoding $ myencodeLangViews langViews
base16String = show (B16.encode $ LBS.toStrict encodedViews)

lang :: Int
lang = 0


offerDatum :: TradeDatum
offerDatum = Offer TradeDetails {
  tradeOwner = "891b125ead0b020033ef53b85646a031b6060b5a3b028fad35094b76",
  budId = "0",
  requestedAmount = 100000000
}

offerRedeemer :: TradeAction
offerRedeemer = Cancel


writePlutusScript :: Integer -> FilePath -> PlutusScript PlutusScriptV1 -> SBS.ShortByteString -> IO ()
writePlutusScript scriptnum filename scriptSerial scriptSBS =
  do
  print $ "Datum value: " <> encode (scriptDataToJson ScriptDataJsonDetailedSchema $ fromPlutusData (Plutus.toData offerDatum))
  print $ "Redeemer value: " <> encode (scriptDataToJson ScriptDataJsonDetailedSchema $ fromPlutusData (Plutus.toData offerRedeemer))
  -- print $ base16String
  result <- writeFileTextEnvelope filename Nothing scriptSerial
  case result of
    Left err -> print $ displayError err
    Right () -> return ()
