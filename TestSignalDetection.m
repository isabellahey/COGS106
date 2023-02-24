function tests = TestSignalDetection
  tests = functiontests(localfunctions);
end

function testDPrimeZero(testCase)

  obj      = SignalDetection(15, 5, 15, 5);
  actual   = obj.d_prime();
  expected = 0;
  verifyEqual(testCase, actual, expected, 'AbsTol', 1e-6);
  
end

function testDPrimeNonzero(testCase)
  
  obj      = SignalDetection(15, 10, 15, 5);
  actual   = obj.d_prime();
  expected = -0.421142647060282;
  verifyEqual(testCase, actual, expected, 'AbsTol', 1e-6);
  
end

function testCriterionZero(testCase)

  obj = SignalDetection(5, 5, 5, 5);
  actual = obj.criterion();
  expected = 0;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);
  
end

function testCriterionNonzero(testCase)

  obj = SignalDetection(15, 10, 15, 5);
  actual = obj.criterion();
  expected = -0.463918426665941;
  testCase.verifyEqual(actual, expected, 'AbsTol', 1e-6);
  
end

function testCorruptedObject(testCase)
    % create object with arbitrary values
    sd = SignalDetection(10, 5, 2, 8);

    % corrupt object by changing properties
    sd.hits = 0;
    sd.misses = 0;
    sd.falseAlarms = 0;
    sd.correctRejections = 0;

    % check if hit rate and false alarm rate are NaN
    verifyTrue(testCase, isnan(sd.hits_rate()));
    verifyTrue(testCase, isnan(sd.falsealarms_rate()));

    % check if d' and criterion are NaN
    verifyTrue(testCase, any(isnan(sd.d_prime())));
    verifyTrue(testCase, any(isnan(sd.criterion())));
end
