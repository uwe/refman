package RefMan::Demo::Account13;

use strict;
use warnings;
use bigint;

sub account { "0x13b311591f2448efab45699d7c16292c601933c1" }

sub data {
  {
    deposits => [
      {
        amount => 490388480637389,
        pricePerFullShare => 1161616908671007802,
        shares => 422160246615588,
        transaction => {
          blockNumber => 11760732,
          id => "0x00215adeb7782be5041ebd5dcfc720fe95053d0bc9a8dad8c7d4d4e200e4a31d",
          timestamp => 1612056596,
        },
        vault => { id => "0x1862a18181346ebd9edaf800804f89190def24a5" },
      },
      {
        amount => 57358939256396,
        pricePerFullShare => 1253033006574627720,
        shares => 45776080083634,
        transaction => {
          blockNumber => 11965836,
          id => "0xadc422780df0189078a5a116c624d54e2690c7308df1a21695a125f42b4cb946",
          timestamp => 1614781782,
        },
        vault => { id => "0x1862a18181346ebd9edaf800804f89190def24a5" },
      },
      {
        amount => 320802273,
        pricePerFullShare => 1188119334779198640,
        shares => 176724236239300786,
        transaction => {
          blockNumber => 11964566,
          id => "0xc878619a71c80ec0788a9b759639dd72df5630b74c13d0dc1f6244988597f10d",
          timestamp => 1614765142,
        },
        vault => { id => "0x7e7e112a68d8d2e221e11047a72ffc1065c38e1a" },
      },
      {
        amount => 65140270,
        pricePerFullShare => 1217852883416741355,
        shares => 53487799,
        transaction => {
          blockNumber => 11842052,
          id => "0x4c82f690bf1b0f3d451f9afd9be9be931007f93cf7398784ba3124ea23a378b6",
          timestamp => 1613136271,
        },
        vault => { id => "0x88128580acdd9c04ce47afce196875747bf2a9f6" },
      },
      {
        amount => 6916536135846897319,
        pricePerFullShare => 1008398822577408904,
        shares => 6858929206371574401,
        transaction => {
          blockNumber => 11760820,
          id => "0x825ddcd008c6fd22975b108de979a9bcef319a3e411db086f79c5aa4b53b7697",
          timestamp => 1612057675,
        },
        vault => { id => "0xb9d076fde463dbc9f915e5392f807315bf940334" },
      },
      {
        amount => 422795073,
        pricePerFullShare => 1187661083342027528,
        shares => 355989667,
        transaction => {
          blockNumber => 11805961,
          id => "0xd03a503f5aa03da64157bf56bde207e14039902bf526c922464d0d6c166229e8",
          timestamp => 1612656834,
        },
        vault => { id => "0xc17078fdd324cc473f8175dc5290fae5f2e84714" },
      },
    ],
    id => "0x13b311591f2448efab45699d7c16292c601933c1",
    vaultBalances => [
      {
        netDeposits       => 0,
        netDepositsRaw    => 0,
        shareBalance      => 0,
        totalDeposited    => 0.000547747419893785,
        totalDepositedRaw => 547747419893785,
        totalReceived     => 0.000600557029860274,
        totalReceivedRaw  => 600557029860274,
        totalSent         => 0.000547747419893785,
        totalSentRaw      => 547747419893785,
        totalWithdrawn    => 0.000600557029860274,
        totalWithdrawnRaw => 600557029860274,
        underlyingToken   => { name => "SushiSwap LP Token" },
        vault             => { id => "0x1862a18181346ebd9edaf800804f89190def24a5" },
      },
      {
        netDeposits       => 0.072478679,
        netDepositsRaw    => 72478679,
        shareBalance      => 0,
        totalDeposited    => 0.320802273,
        totalDepositedRaw => 320802273,
        totalReceived     => 0,
        totalReceivedRaw  => 0,
        totalSent         => 0,
        totalSentRaw      => 0,
        totalWithdrawn    => 0.248323594,
        totalWithdrawnRaw => 248323594,
        underlyingToken   => { name => "Digg" },
        vault             => { id => "0x7e7e112a68d8d2e221e11047a72ffc1065c38e1a" },
      },
      {
        netDeposits       => 0,
        netDepositsRaw    => 0,
        shareBalance      => 0,
        totalDeposited    => "0.00000000006514027",
        totalDepositedRaw => 65140270,
        totalReceived     => "0.000000000070298646",
        totalReceivedRaw  => 70298646,
        totalSent         => "0.00000000006514027",
        totalSentRaw      => 65140270,
        totalWithdrawn    => "0.000000000070298646",
        totalWithdrawnRaw => 70298646,
        underlyingToken   => { name => "SushiSwap LP Token" },
        vault             => { id => "0x88128580acdd9c04ce47afce196875747bf2a9f6" },
      },
      {
        netDeposits       => 0,
        netDepositsRaw    => 0,
        shareBalance      => 0,
        totalDeposited    => "6.916536135846897319",
        totalDepositedRaw => 6916536135846897319,
        totalReceived     => "6.928692944533292507",
        totalReceivedRaw  => 6928692944533292507,
        totalSent         => "6.916536135846897319",
        totalSentRaw      => 6916536135846897319,
        totalWithdrawn    => "6.928692944533292507",
        totalWithdrawnRaw => 6928692944533292507,
        underlyingToken   => { name => "Curve.fi tBTC/sbtcCrv" },
        vault             => { id => "0xb9d076fde463dbc9f915e5392f807315bf940334" },
      },
      {
        netDeposits       => 0,
        netDepositsRaw    => 0,
        shareBalance      => 0,
        totalDeposited    => "0.000000000422795073",
        totalDepositedRaw => 422795073,
        totalReceived     => "0.000000000470440161",
        totalReceivedRaw  => 470440161,
        totalSent         => "0.000000000422795073",
        totalSentRaw      => 422795073,
        totalWithdrawn    => "0.000000000470440161",
        totalWithdrawnRaw => 470440161,
        underlyingToken   => { name => "Uniswap V2" },
        vault             => { id => "0xc17078fdd324cc473f8175dc5290fae5f2e84714" },
      },
    ],
    withdrawals => [
      {
        amount => 600557029860274,
        pricePerFullShare => 1283416130772633138,
        shares => 467936326699222,
        transaction => {
          blockNumber => 12144668,
          id => "0xc3cfb25d7f3459fdd617835962d69969e823ee147a6be4c1c598e4a863123121",
          timestamp => 1617160696,
        },
        vault => { id => "0x1862a18181346ebd9edaf800804f89190def24a5" },
      },
      {
        amount => 248323594,
        pricePerFullShare => 1215584214123104410,
        shares => 176724236239300786,
        transaction => {
          blockNumber => 12009492,
          id => "0x6d1e207723986a3fd4685fe513f608d94b127da1e0bb2322f545202f8743cc10",
          timestamp => 1615361834,
        },
        vault => { id => "0x7e7e112a68d8d2e221e11047a72ffc1065c38e1a" },
      },
      {
        amount => 70298646,
        pricePerFullShare => 1314293128163423833,
        shares => 53487799,
        transaction => {
          blockNumber => 12009470,
          id => "0x794d71dd6b350c260048518afa43a49779fd11dac072bb2ee72294c49d3696b7",
          timestamp => 1615361546,
        },
        vault => { id => "0x88128580acdd9c04ce47afce196875747bf2a9f6" },
      },
      {
        amount => 6928692944533292507,
        pricePerFullShare => 1010171228782608131,
        shares => 6858929206371574401,
        transaction => {
          blockNumber => 11887284,
          id => "0x536c418ec942da23108a378b4d003c2edb52b2e64e1e50d1d10ecd1b093c9bad",
          timestamp => 1613736846,
        },
        vault => { id => "0xb9d076fde463dbc9f915e5392f807315bf940334" },
      },
      {
        amount => 45116277,
        pricePerFullShare => 1267347977974447203,
        shares => 35598966,
        transaction => {
          blockNumber => 11887610,
          id => "0x31fb353407510e4923b8da11c28a24d8e72924dbe9e0ae813389b04be6459e21",
          timestamp => 1613741075,
        },
        vault => { id => "0xc17078fdd324cc473f8175dc5290fae5f2e84714" },
      },
      {
        amount => 425323884,
        pricePerFullShare => 1327516321695594389,
        shares => 320390701,
        transaction => {
          blockNumber => 12009398,
          id => "0x590a1be7b9eb5548a64ae0dfb3d5192555a0fd1b330d915a42b4f95ecb3c5be1",
          timestamp => 1615360662,
        },
        vault => { id => "0xc17078fdd324cc473f8175dc5290fae5f2e84714" },
      },
    ],
  }
}

1;
