from starlette.testclient import TestClient


def test_root_endpoint(test_client: TestClient):
    r = test_client.get("/")
    assert r.status_code == 200
