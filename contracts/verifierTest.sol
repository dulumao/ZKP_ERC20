//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// 2019 OKIMS
//      ported to solidity 0.5
//      fixed linter warnings
//      added requiere error messages
//
pragma solidity >=0.5.0;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() internal pure returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() internal pure returns (G2Point memory) {
        // Original code point
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );

/*
        // Changed by Jordi point
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
*/
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) internal pure returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    ///  the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success,"pairing-add-failed");
    }
    /// the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success,"pairing-mul-failed");
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length,"pairing-lengths-failed");
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success,"pairing-opcode-failed");
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
interface InterfaceVerifier {
    function verifyProofSender(uint[2] memory a,uint[2][2] memory b,uint[2] memory c,uint[3] memory input) external view returns (bool r);
    function verifyProofReceiver(uint[2] memory a,uint[2][2] memory b,uint[2] memory c,uint[3] memory input) external view returns (bool r);

}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alfa1;
        Pairing.G2Point beta2;
        Pairing.G2Point gamma2;
        Pairing.G2Point delta2;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G2Point B;
        Pairing.G1Point C;
    }
    function verifyingKey() internal pure returns (VerifyingKey memory vk) {
        vk.alfa1 = Pairing.G1Point(19746878195654911286068663295233252160225796114032157102682022608616433236084,21811638024084225565890803487359858677148682125126869016599169256075663790115);
        vk.beta2 = Pairing.G2Point([11028396871454167194599708294920119198100265337173835493813819209190552405825,9454741710984173206180891129800769080989434718264008522971227160349205851320], [9266030281962741590779614199265736907891642602095638669273524666361499979938,415672171303069655951681735530472152581273414319968349754446461815969199736]);
        vk.gamma2 = Pairing.G2Point([21418157900180931994238355221640167940664453444198700649191660381796860297225,19533504984937751043111314952275682328673478571554346207697512395343963793010], [11133947020919790816872553411959072029897107198250785061623475120216492121530,15256146644465487758096738862315528671363432485653239323465667040054650200170]);
        vk.delta2 = Pairing.G2Point([20063646999891116220280663167272320722040597296333619659890954560367441754435,18705882098747889832778191850007326259329480042479745589764218487965697855771], [15200720432566304550699918943420019215751269730832499571290473001236258120875,6350021097376808462906493801075823272734712874666437256155352274894251600725]);
        vk.IC = new Pairing.G1Point[](4);
        vk.IC[0] = Pairing.G1Point(21461894137130735394781108084243145404720675580831694397314230364543990150459,12485101595847128167866468046168855831502328993279326860679421283963666182488);
        vk.IC[1] = Pairing.G1Point(20659448832498159572100377579178055825126437895288242938315844219376676819656,18826794988257013575723304495273080014219067996689841090483093437709760549010);
        vk.IC[2] = Pairing.G1Point(10485011889120676080361032468747982759653902205405615429596052761814368213165,16516008617953888864218054592223608333591871818539257432868805976069396455252);
        vk.IC[3] = Pairing.G1Point(18852381380347376821464473406294770962436688205312428768938807823049768437503,8788454416130917724717359853673138632651518287576835943485594945578253260185);

    }

    function verifyingKeyReceiver() internal pure returns (VerifyingKey memory vk) {
        vk.alfa1 = Pairing.G1Point(2073638128396579402106897469138812159808282535033485615993681313178964145078,12456895114540857806914113339428134215190079289053535097985205769068576088823);
        vk.beta2 = Pairing.G2Point([19615470737680842366151001515302925526350733434620475891873806474328040846987,21761700499647133379215145899464034787856993186861498076458018116201915189710], [21580578982859696700758623868883816968589579046278560496608390639876376587034,6773212036777434506811828414935356905986550517374187612411308164142636657826]);
        vk.gamma2 = Pairing.G2Point([15767767146794596329206127169373203168653513061911970469427427302404015430789,9971914854231132087385448082037602507359380554349785202440642772873996432119], [15895802204366379677044881927270201009899905020634355469765029500051991978342,2747631498708713159641935048777660248871896682309698955359283507875016769370]);
        vk.delta2 = Pairing.G2Point([17921846574887480971959560216556254113025624061450051816077410323293524412485,13700433909248572632125328204727662083877480744206798048940446111728533453192], [15377438446355399710823745445217559448440220222516185467761214555951992546478,5975962837540615340649045732356824484984051100205464479351492913791430435908]);
        vk.IC = new Pairing.G1Point[](4);
        vk.IC[0] = Pairing.G1Point(21611054146754075895954443106369685073373193171250835144007571794950922640548,5265877211531879383648997215598284173094516704667000131917155282026760121689);
        vk.IC[1] = Pairing.G1Point(15869708131106525326411473807842936539651189238295597068598739447844777578701,16411232120203425052003877730144166478400130975455913716758614829737678325736);
        vk.IC[2] = Pairing.G1Point(2637972845168641702716678756801127103485213435958039637617557836058057446736,4421120410898008694908696396310096228174834387637223293857097584246072789233);
        vk.IC[3] = Pairing.G1Point(2759137862396661817041674280624313231838918559959826787218390949746507683987,15699946709647134283562504142153787386354089409489540244397540459155139924763);

    }
    function verify(uint[] memory input, Proof memory proof, VerifyingKey memory _vk) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = _vk;
        require(input.length + 1 == vk.IC.length,"verifier-bad-input");
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field,"verifier-gte-snark-scalar-field");
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd4(
            Pairing.negate(proof.A), proof.B,
            vk.alfa1, vk.beta2,
            vk_x, vk.gamma2,
            proof.C, vk.delta2
        )) return 1;
        return 0;
    }
    function verifyProofSender(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[3] memory input
        ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof, verifyingKey()) == 0) {
            return true;
        } else {
            return false;
        }
    }
    function verifyProofReceiver(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[3] memory input
        ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof, verifyingKeyReceiver()) == 0) {
            return true;
        } else {
            return false;
        }
    }
}
