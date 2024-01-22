//
//  Memos.swift
//  todayMovie
//
//  Created by 한상진 on 1/22/24.
//

import Foundation

/// 비동기 처리는 일단 closure
/// closure -> Combine or async/await로 바꿀거에요 -> 개념학습 2주 +, 코드를 변환 2주 +
///
/// 꼭은 아니지만 확실하게 좋은 곳 붙으려면 해야하는
/// 1. 아키텍쳐
/// MVC -> MVVM
/// MVVM -> Clean Architecture
/// Clean Architecture -> 지하님의 선택에 맞는 아키텍쳐를 만들기 (아마 하기 힘들거구)
/// 
/// 1.5 최적화
/// reloadData
/// 
/// 2. 모듈화
/// TodayMovie -> Movie
///         -> UI
///         -> Account 
///         -> Nework
/// 
/// command + B -> xcode가 어떻게 빌드를 해서 어떤 순서로 바이너리 파일들을 만드는지
/// 
/// 신입한테 기대를 할 수도, 안 할수도
/// 만약에 물어봤는데, 대답을 잘한다 -> 엄청난 +
/// 
/// 5년차 되도 모르는 사람들이 많음
/// 
/// 유행이고, 사람들이 많이 요즘 관심을 가지는
/// 
/// 3. 테스트코드 작성
///  
/// 과제 국룰
/// 구조: MVVM -> CleanArchitecture
/// 비동기: async / combine / rxswift
/// 테스트코드: optional +점수, 요구사항 -> SOLID, POP -> 추상화, 의존성 주입, MVVM -> 뷰, 비지니스 로직
/// swift 기초지식들을 완벽하게 알기
///
/// 1월 15일 기준
/// 숙제
/// 1. 뷰에서 바인딩 시 insert 구현
/// 2. 뷰모델 로직 정리
/// 
/// 뷰 관련 이슈들
/// 1. 검색어를 입력받아서 영화 검색하기
/// 2. 기본적으로 내장되어야할 파라미터 분리

/// 4. 에러처리
/// 
/// 뷰모델 관련 이슈들

/// 2. 뷰모델 구현 고도화
///
/// 기타 기능 
/// 1. 이미지 캐싱 고도화
///     1.1) 로드하는 아이와, 캐시를 들고있는 아이를 분리
///     1.2) 캐시를 actor로 변환
///     1.3) memory cache, disk cache 구현
/// 2. 테스트 코드 작성 

// movie를 가져올 때 마다 datasource도 새로 만들고, snapshot도 새로 만들고, 모든 movie를 넣어주고 있는 중
// reload를 하는거보다 더 오버헤드가 커요

/* 바뀐 애들을 넣었을 때 insert
 var snapshot: SnapShot = self.dataSource.snapshot() // 기존 snapshot [1, 2, 3, 4, 5]
 snapshot.appendItems(movies) // 새로 더해질 무비의 배열 movies [6, 7, 8, 9, 10]
 // 바뀐 snapshot = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 self.dataSource.apply(snapshot) // dataSource가 알아서 비교해서 더해줘요
 */

/// [movie]을 받아서
/// reloadData 사용 없이
/// tableview insert -> 어려울 수 있음
///
/// diffable datasource -> 새로 공부하는 것도 어려울 수 있어요

/// 어떤 행동을 할지 x
/// 함수 이름은 어떤 행동이 일어났는지
/// Action

// todo: 땡기면 꺼지는 에러가 생겨서 수정 필요

/// 문제점 1. 하나의 함수가 너무 여러개의 일을 하고 있어요.
/// 1. 파라미러틀 정의하고
/// 2. tableView의 상태와 page의 상태 관리
/// 3. networkClient.request
/// 4. result에 대한 성공 핸들링
/// 5. result에 대한 실패 핸들링
///
/// 숙제2:
/// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting
/// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety
/// https://medium.com/@almalehdev/you-dont-always-need-weak-self-a778bec505ef
///
/// 숙제3:
/// 처음 data를 받아오는 함수와
/// pagination으로 받아오는 함수를 분리하면 좋을 것 같아요.
///
/// 숙제4:
/// 에러처리 -> 알럿을 띄워서
/// 재시도 버튼과 취소 버튼
/// 재시도 시 다시 (전에 시도한) API를 찔러오는 것
/// 취소시 취소

// 이친구들은 뷰모델이 아니라 뷰에 있어야해요.
// 객체를 만들거나, protocol화 해서 사용하면 좋음

// 뷰모델은 상태를 바꿔주는 아이.
// 뷰모델의 상태에 따라 뷰의 상태를 바꿔주도록

/// ------------------------------------------------------
/// `1월 22일 숙제`
/// 1. combine 제거하고 뷰모델이랑 다시 바인딩 하기
/// 2. 바인딩 한 뒤에, insert로 전체 업데이트 하지 않고 이쁘게 넣기
/// 3. pagination 안되는거 디버깅 후 처리
/// 3. 에러처리 다시
/// 4. image cache도 아예 다시
/// ------------------------------------------------------
